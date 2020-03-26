package com.memoko.integrated.storagetest;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
//[START gcs_imports]
import com.google.appengine.tools.cloudstorage.GcsFileOptions;
import com.google.appengine.tools.cloudstorage.GcsFilename;
import com.google.appengine.tools.cloudstorage.GcsInputChannel;
import com.google.appengine.tools.cloudstorage.GcsOutputChannel;
import com.google.appengine.tools.cloudstorage.GcsService;
import com.google.appengine.tools.cloudstorage.GcsServiceFactory;
import com.google.appengine.tools.cloudstorage.RetryParams;
//[END gcs_imports]
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.channels.Channels;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
/**
 * Servlet implementation class GcsExampleServlet
 */
//@WebServlet("/GcsExampleServlet")
/**
 * A simple servlet that proxies reads and writes to its Google Cloud Storage bucket.
 */
@SuppressWarnings("serial")
public class GcsExampleServlet extends HttpServlet {
//	private static final long serialVersionUID = 1L;
	
	public static final boolean SERVE_USING_BLOBSTORE_API = false;
    /**
     * @see HttpServlet#HttpServlet()
     */
//    public GcsExampleServlet() {
//        super();
//        // TODO Auto-generated constructor stub
//    }

	/**
	   * This is where backoff parameters are configured. Here it is aggressively retrying with
	   * backoff, up to 10 times but taking no more that 15 seconds total to do so.
	*/
	private final GcsService gcsService = GcsServiceFactory.createGcsService(new RetryParams.Builder()
			.initialRetryDelayMillis(10)
			.retryMaxAttempts(10)
			.totalRetryPeriodMillis(15000)
			.build());
	
	
	/**Used below to determine the size of chucks to read in. Should be > 1kb and < 10MB */
	private static final int BUFFER_SIZE = 2 * 1024 * 1024;
	
	
	/**
	   * Retrieves a file from GCS and returns it in the http response.
	   * If the request path is /gcs/Foo/Bar this will be interpreted as
	   * a request to read the GCS file named Bar in the bucket Foo.
	   */
	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		GcsFilename fileName = getFileName(request);
		
		if(SERVE_USING_BLOBSTORE_API) {
			BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
			BlobKey blobKey = blobstoreService.createGsBlobKey(
					"/gs/" + fileName.getBucketName() + "/" + fileName.getObjectName());
			blobstoreService.serve(blobKey, response);
		} else {
			GcsInputChannel readChannel = gcsService.openPrefetchingReadChannel(fileName, 0, BUFFER_SIZE);
			copy(Channels.newInputStream(readChannel),response.getOutputStream());
		}
	}

	 /**
	   * Writes the payload of the incoming post as the contents of a file to GCS.
	   * If the request path is /gcs/Foo/Bar this will be interpreted as
	   * a request to create a GCS file named Bar in bucket Foo.
	   */
	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
		GcsFileOptions instance = GcsFileOptions.getDefaultInstance();
		GcsFilename fileName = getFileName(request);
		GcsOutputChannel outputChannel;
		outputChannel = gcsService.createOrReplace(fileName, instance);
		copy(request.getInputStream(), Channels.newOutputStream(outputChannel));
	}

	
	private GcsFilename getFileName(HttpServletRequest request) {
		String[] splits = request.getRequestURI().split("/",4);
		if(!splits[0].equals("") || !splits[1].equals("gcs")) {
			throw new IllegalArgumentException("The URL is not formed as expected. " +
		"Expecting /gcs/<butket>/<object>");
		}
		
		return new GcsFilename(splits[2],splits[3]);
	}
	
	  /**
	   * Transfer the data from the inputStream to the outputStream. Then close both streams.
	   */
	private void copy(InputStream input, OutputStream output) throws IOException{
		try {
			byte[] buffer = new byte[BUFFER_SIZE];
			int bytesRead = input.read(buffer);
			while(bytesRead != -1) {
				output.write(buffer,0,bytesRead);
				bytesRead = input.read(buffer);
			}
		} finally {
			input.close();
			output.close();
		}
	}
}
