grp.sql

set serveroutput on;

create table member (
    m_no varchar(20) PRIMARY KEY,
    m_name varchar(20) NOT NULL,
    m_type varchar(20),
    no_of_books number(4),
    total_fine number(4)
);

create table book (
    b_no varchar(20) PRIMARY KEY,
    b_name varchar(20) NOT NULL,
    author varchar(20),
    price varchar(20),
    no_of_books number(4)
);

create table transaction (
    b_no varchar(20),
    m_no varchar(20),
    issue_date date,
    due_date date,
    ruturn_date date,
    constraint BID_FKEY
    FOREIGN KEY (b_no) REFERENCES book(b_no),
    CONSTRAINT MID_FKEY
    FOREIGN KEY(m_no) REFERENCES member(m_no)
);


create table transaction_history (
    b_no varchar(20),
    m_no varchar(20),
    issue_date date,
    due_date date,
    return_date date,
    CONSTRAINT BID_FKEY1
    FOREIGN KEY(b_no) REFERENCES book(b_no),
    CONSTRAINT MID_FKEY1
    FOREIGN KEY(m_no) REFERENCES member(m_no)
);


INSERT INTO member VALUES(
    '1',
    'DEEPESH',
    'M',
    2,
    NULL
);

INSERT INTO member VALUES(
    '2',
    'PRIYANSH',
    'L',
    0,
    NULL
);

INSERT INTO member VALUES(
    '3',
    'AKASH',
    'Y',
    2,
    NULL
);

INSERT INTO member VALUES(
    '4',
    'SWATI',
    'M',
    4,
    NULL
);

INSERT INTO member VALUES(
    '5',
    'BOSS',
    'L',
    1,
    NULL
);

INSERT INTO member VALUES(
    '6',
    'PRATIKHYA',
    'Y',
    1,
    NULL
);

INSERT INTO member VALUES(
    '7',
    'DHRUTI',
    'L',
    2,
    NULL
);

INSERT INTO book VALUES(
    'B1',
    'YES YOU CAN WIN!',
    'GAREY V',
    '200',
    2
);

INSERT INTO book VALUES(
    'B2',
    'HALF GIRLFRIEND',
    'CHETAN BHAGAT',
    '100',
    3
);

INSERT INTO book VALUES(
    'B3',
    'HOW I MET UR MOTHER?',
    'BARNEY SINSTON',
    '500',
    5
);

INSERT INTO book VALUES(
    'B4',
    'CORPORATE CHANAKYA',
    'MIRAL',
    '170',
    5
);

INSERT INTO book VALUES(
    'B5',
    'LIFE AT EDGE',
    'TDP',
    '650',
    0
);

INSERT INTO book VALUES(
    'B6',
    'VIVEK GEETA!',
    'KABIR',
    '180',
    2
);


INSERT INTO transaction VALUES(
    'B4',
    '7',
    '01-MAY-20',
    '05-MAY-20',
    '07-MAY-20'
);

INSERT INTO transaction VALUES(
    'B3',
    '5',
    '01-MAY-20',
    '05-MAY-20',
    NULL
);

INSERT INTO transaction VALUES(
    'B3',
    '2',
    '07-MAY-20',
    '14-MAY-20',
    NULL
);

INSERT INTO transaction VALUES(
    'B6',
    '3',
    '07-MAY-20',
    '14-MAY-20',
    NULL
);

INSERT INTO transaction VALUES(
    'B1',
    '1',
    '07-MAY-20',
    '14-MAY-20',
    NULL
);


/*proceedure for issuing book*/

create or replace procedure insert1(book_id varchar,member_id number)
IS
    a boolean default false;
    b boolean default false;
    c boolean default false;
    d boolean default false;

    mep number(4);
    tep number(4);
    sep number(4);
    bep number(4);
    mb number(4);
    dat varchar(10);
    typ varchar(10);
    expiry_date date;
    ddate date;

BEGIN

    select count(*) into tep from book where b_no=book_id;

    if tep=1
        then
            dbms_output.put_line('THIS BOOK '||book_id||' EXIST IN LIBRARY.');
        ELSE   
            dbms_output.put_line('THIS BOOK '||book_id||' DOES NOT EXIST IN LIBRARY.');
    end if;


    select count(*) into mep from member where m_no=member_id;

    if mep=1
        then
            dbms_output.put_line('THE USER '||member_id||' IS FROM THE CLUB.');
        else 
            dbms_output.put_line('THE USER '||member_id||' IS NOT FROM THE CLUB.');
    end if;

    select count(*) into sep from transaction where b_no=book_id AND m_no=member_id AND ruturn_date is NULL;

    if sep=1
        THEN
            dbms_output.put_line('THE USER ALREADY HAVE THIS BOOK.');
    END IF;

    select m_type into typ from member where m_no=member_id;
    expiry_date:= ADD_MONTHS(ROUND(SYSDATE,'MONTH'),1);
    ddate:=ROUND(SYSDATE,'YEAR');

    if typ='M'
    THEN
        IF expiry_date<sysdate+7
            THEN
                a:=TRUE;
                dbms_output.put_line('YOUR MEMBERSHIP EXPIRY DATE '||expiry_date||' IS BEFORE DUE DATE '||sysdate+7||'.');
            end if;
    ELSIF typ='Y'
    THEN
        IF ddate<SYSDATE+7
        THEN    
            a:=TRUE;
            dbms_output.put_line('YOUR MEMBERSHIP EXPIRY DATE '||expiry_date||' IS BEFORE DUE DATE '||SYSDATE+7||'.');
        END IF;
    ELSIF typ='L'
    THEN    
        dbms_output.put_line('YOU HAVE LIFETIME MEMBERSHIP.');
    END IF;

    SELECT no_of_books INTO mb FROM member WHERE m_no=member_id;

    IF typ='M'
    THEN
        IF mb>=4
        THEN   
            b:=TRUE;
            dbms_output.put_line('YOU HAVE REACHED MONTHLY BORROW LIMIT OF 4 BOOKS.');
        END IF;
    ELSIF typ='Y'
    then
        IF mb>=2
        THEN
            b:=TRUE;
            dbms_output.put_line('YOU HAVE REACHED YEARLY BORROW LIMIT OF 2 BOOKS.');
        END IF;
    ELSIF typ='L'
    THEN    
        IF mb>=6
        THEN
            b:=TRUE;
            dbms_output.put_line('YOU HAVE REACHED LIFETIME BORROW LIMIT OF 6 BOOKS.');
        END IF;
    END IF;

    SELECT no_of_books INTO bep FROM book WHERE b_no=book_id;

    IF bep>=1
    THEN
        d:=TRUE;
        dbms_output.put_line('THE BOOK IS AVAILABLE IN LIBRARY.');
    END IF;

    
    SELECT TO_CHAR(SYSDATE,'DAY') INTO dat FROM DUAL;

    IF dat='SUN'
    THEN
        dbms_output.put_line('IT IS '||TO_CHAR(SYSDATE,'DAY')||' SO CANNOT ISSUE THE BOOK.');
    ELSIF dat='SAT'
    THEN
        dbms_output.put_line('IT IS '||TO_CHAR(SYSDATE,'DAY')||' SO CANNOT ISSUE THE BOOK.');
    ELSE
        c:=TRUE;
        dbms_output.put_line('IT IS '||TO_CHAR(SYSDATE,'DAY')||' SO CAN ISSUE BOOK.');
    END IF;

    IF (tep IS NOT NULL AND mep IS NOT NULL AND b IS NOT NULL AND a IS NOT NULL AND d IS NOT NULL AND c IS NOT NULL)
    THEN
        INSERT INTO transaction VALUES(book_id,member_id,SYSDATE,SYSDATE+7,NULL);
        dbms_output.put_line('ITS WORKING');
    END IF;
END;
/

/*PROCEDURE FOR RETURNING BOOK*/

CREATE OR REPLACE PROCEDURE return_book(book_id varchar,member_id number)
IS
    fine number(20);
    memid number(20);
    retrn_date date not NULL:='07-MAY-20';
    dat VARCHAR(5);
    do date;
BEGIN

    select m_no into memid from transaction where m_no=member_id and b_no=book_id;

    update transaction set ruturn_date='07-MAY-20' where b_NO=book_id and m_no=member_id;
    select due_date into do from transaction where b_no=book_id and m_no=member_id;

    fine:=(do-retrn_date)*5;

    dbms_output.put_line('FINE IS '||fine);

    update member set total_fine=fine where m_no=member_id;

    select TO_CHAR(SYSDATE,'DAY') into dat from dual;

    if dat='SUN'
    THEN
        dbms_output.put_line('IT IS '||TO_CHAR(SYSDATE,'DAY')||' SO TOU CANNOT RETURN BOOK.');
    END IF;

    if dat='SAT'
    THEN
        dbms_output.put_line('IT IS '||TO_CHAR(SYSDATE,'DAY')||' SO TOU CANNOT RETURN BOOK.');
    END IF;

EXCEPTION
WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('THERE IS NO ISSUED BOOK TO THIS MEMBER');
END;
/      

/*trigger to increament and decreament the no_of_boks from member and book table upon issue and return*/

create or replace TRIGGER incr_triggers
AFTER INSERT OR UPDATE ON transaction 
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        UPDATE book SET no_of_books=no_of_books-1 WHERE b_no=:NEW.b_no;
        UPDATE member SET no_of_books=no_of_books+1 WHERE m_no=:NEW.m_no;
    ELSIF UPDATING THEN
        UPDATE book SET no_of_books=no_of_books+1 WHERE b_no=:OLD.b_no;
        UPDATE member SET no_of_books=no_of_books-1 WHERE m_no=:OLD.m_no;
    END IF;
END;
/

/*TRIGGER FOR MOVE DATE FROM TRANSACTION TO TRANSACTION HISTORY UPON DELETION*/

CREATE OR REPLACE TRIGGER move_trigger
BEFORE DELETE ON transaction 
FOR EACH ROW 
BEGIN 
    INSERT INTO transaction_history VALUES(:OLD.b_no,:OLD.m_no,:OLD.issue_date,:OLD.due_date,:OLD.ruturn_date);
END;
/