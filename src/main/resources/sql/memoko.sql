--ȸ������ ���̺�
create table Member
(
    Member_id varchar2(200) primary key,                --ȸ�����̵�(�̸���)
    Member_pw varchar2(50) Not null,                     --ȸ��PW 
    Member_nickname varchar2(50) Not null,            --ȸ���г���
    Member_email varchar2(200) Not null,                --ȸ���̸���
    Member_favorite varchar2(200)                           --ȸ����ȣ����
);

--��ȸ
select * from Member;

--���
insert into Member
(
    Member_id,
    Member_pw,
    Member_nickname,
    Member_email,
    Member_favorite
)
VALUES
(   'miko1234@naver.com',
    'abcd1234',
    '����',
    'miko1234@naver.com',
    '��ũ��'
);

--����
update
    Member
set
    Member_pw = '1234abcd',
    Member_nickname = '����',
    Member_email = '1234miko@naver.com',
    Member_favorite = '�긮����'
where 
    Member_id = 'miko1234@naver.com';


--����
delete
from Member
where Member_id = 'miko1234@naver.com';

------------------------------------------------------------------------------------------------









--������ ���̺�
create table Recipe
(
    Recipe_num number primary key,                      --�����ǹ�ȣ
    Member_id varchar2(200) not null,                     --�ۼ���ID
    Recipe_title varchar2(200) not null,                     --����������
    Recipe_indate date default sysdate,                    --�����ǵ�ϳ�¥
    Recipe_hits number default 0,                            --��������ȸ��
    Recipe_likes number default 0,                           --���������ƿ��
     CONSTRAINTS Recipe_fk FOREIGN KEY (Member_id)
    REFERENCES Member(Member_id) on delete cascade
);
--���������̺��� ��ȣ ������
create sequence Recipe_SEQ;

--��ȸ


--���
insert into Recipe
(

)











--������ ���� ���̺�(����, ����)
create table Recipe_content
(
    content_num number not null,                          --�����ǳ����ȣ
    Member_id varchar2(200) not null,                     --�ۼ���ID
    Recipe_num number not null,                            --�����ǹ�ȣ
    Recipe_content varchar2(4000) Not null,              --�����ǳ���
    Recipe_image varchar2(500),                               --�������̹���
     CONSTRAINTS Recipe_content_fk1 FOREIGN KEY (Recipe_num)
    REFERENCES Recipe(Recipe_num) on delete cascade
);
--������ ���� ���̺��� ��ȣ ������
create sequence Recipe_content_SEQ;















--������ ��� ���̺�(���, ��)
create table Recipe_ingrd
(
    Recipe_num number not null,                     --�����ǹ�ȣ
    Member_id varchar2(200) not null,               --�ۼ���ID
    ingrd_num number not null,                            --����ȣ
    ingrd_name varchar2(50) not null,                --����̸�
    ingrd_amount varchar2(50) not null,             --����
    CONSTRAINTS Recipe_ingrd_fk1 FOREIGN KEY (Recipe_num)
    REFERENCES Recipe(Recipe_num) on delete cascade
);
--������ ���  ���̺� ��ȣ ������
create sequence Recipe_ingrd_SEQ;

--�����Ǹ� ���ƿ� �� ȸ�����
create table Recipe_likes
(
    Recipe_num number not null,
    Member_id varchar2(200) not null,
    CONSTRAINTS Recipe_likes_fk1 FOREIGN KEY (Recipe_num)
    REFERENCES Recipe(Recipe_num) on delete cascade
);
















--���� ���̺�
create table Review
(
    Review_num number primary key,                      --�����ȣ
    Member_id varchar2(200) not null,                      --�ۼ���ID
    Review_title varchar2(200) not null,                     --��������
    Review_content varchar2(2000) not null,              --���䳻��
    Review_image varchar2(500),                               --�����̹���(1��)
    Review_indate date default sysdate,                    --�����ϳ�¥
    Review_likes number default 0,                           --�������ƿ��
    CONSTRAINTS Review_fk FOREIGN KEY (Member_id)
    REFERENCES Member(Member_id) on delete cascade
);
--���� ���̺� ��ȣ ������
create sequence Review_SEQ;

--���並 ���ƿ� �� ȸ�����
create table Review_likes
(
    Review_num number not null,                                     --���� ��ȣ
    Member_id varchar2(200) not null,                               --�ۼ��� ���̵�
    CONSTRAINTS Review_likes_fk1 FOREIGN KEY (Review_num)
    REFERENCES Review(Review_num) on delete cascade
);

--������ ����
create table Review_reply
(
    Reply_num number primary key,                   --���� ��ȣ
    Review_num number not null,                      --���� ��ȣ
    Member_id varchar2(200) not null,                --�ۼ��� ���̵�
    Reply_content varchar2(500) not null,            --���ó���
    Reply_indate date default sysdate,                --���õ�Ͻð�
     CONSTRAINTS Review_reply_fk1 FOREIGN KEY (Review_num)
    REFERENCES Review(Review_num) on delete cascade
);
--���� ���̺� ��ȣ ������
create sequence Review_reply_SEQ;




