CREATE DATABASE    QLDA
ON PRIMARY
(    NAME= QLDA_Primary,
    FILENAME='D:\BTTO\DATABASE\TUAN_3\QLBH_P.mdf',
    SIZE=50MB,     MAXSIZE=UNLIMITED,     FILEGROWTH=100MB    )
LOG ON(
    NAME= QLDA_Log,
    FILENAME='D:\BTTO\DATABASE\TUAN_3\QLBH_log.ldf',
    SIZE=8MB,     MAXSIZE=UNLIMITED,     FILEGROWTH=10%)

USE QLDA;
GO
-- Tạo bảng Nhân Viên
CREATE TABLE NHANVIEN
(
    HONV nvarchar(15),
    TENLOT nvarchar(15),
    TENNV nvarchar(15),
    MANV char(9),
    NGSINH date,
    DCHI nvarchar(30),
    PHAI nvarchar(3),
    LUONG float,
    MA_NQL  char(9),
    PHG  int,
    PRIMARY KEY (MANV)
)

-- Tạo bảng Đề Án
CREATE TABLE DEAN
(
    TENDA nvarchar(15),
    MADA int,
    DDIEM_DA nvarchar(15),
    PHONG int,
    PRIMARY KEY (MADA)
)

-- Tạo bảng Công Việc
CREATE TABLE CONGVIEC
(
    MADA int,
    STT int,
    TEN_CONG_VIEC nvarchar(50),
    PRIMARY KEY (MADA, STT)
)

-- Tạo bảng Phòng Ban
CREATE TABLE PHONGBAN
(
    TENPHG nvarchar(15),
    MAPHG int,
    TRPHG char(9),
    NG_NHANCHUC date,
    PRIMARY KEY (MAPHG)
)

-- Tạo bảng Phân Công
CREATE TABLE PHANCONG
(
    MA_NVIEN  char(9),
    MADA int,
    STT int,
    THOIGIAN float,
    PRIMARY KEY (MA_NVIEN, MADA, STT)
)

-- Tạo bảng Thân Nhân
CREATE TABLE THANNHAN
(
    MA_NVIEN char(9),
    TENTN nvarchar(15),
    PHAI nvarchar(3),
    NGSINH date,
    QUANHE  nvarchar(15),
    PRIMARY KEY (MA_NVIEN, TENTN)
)

-- Tạo bảng Địa Điểm Phòng
CREATE TABLE DIADIEM_PHG
(
    MAPHG  int,
    DIADIEM nvarchar(15),
    PRIMARY KEY (MAPHG, DIADIEM)
)

ALTER TABLE NHANVIEN ADD CONSTRAINT FK_NHANVIEN FOREIGN KEY(MA_NQL)REFERENCES NHANVIEN(MANV)
ALTER TABLE PHONGBAN ADD CONSTRAINT FK_PHONGBAN FOREIGN KEY(TRPHG)REFERENCES NHANVIEN(MANV)
ALTER TABLE NHANVIEN ADD CONSTRAINT FK_NHANVIEN_2 FOREIGN KEY(PHG)REFERENCES PHONGBAN(MAPHG)

--Câu 2 a i)Viết lệnh thêm 1 dòng dữ liệu vào bảng nhân viên sao cho không báo lỗi
ALTER TABLE NHANVIEN NOCHECK CONSTRAINT FK_NHANVIEN_2

INSERT INTO NHANVIEN VALUES (N'Nguyễn', N'Thanh', N'Trúc', '004', '1/1/2000', N'200 Cống Quỳnh Q1, TP HCM',N'Nam',30000, null, 4)

--Câu 2 a ii)Thêm 1 dòng vào bảng nhân viên sao cho báo lỗi khóa chính

INSERT INTO NHANVIEN VALUES (N'Nguyễn', N'Thanh', N'Trúc', '004', '1/1/2000', N'200 Cống Quỳnh Q1, TP HCM',N'Nữ',40000, null, 4)

--Câu 2 a iii)Sửa lệnh câu ii. sao cho không báo lỗi.

INSERT INTO NHANVIEN VALUES (N'Nguyễn', N'Thanh', N'Trúc', '010', '1/1/2000', N'200 Cống Quỳnh Q1, TP HCM',N'Nữ',40000, null, 4)

--Câu 2 b i)Thêm 1 dòng vào bảng nhân viên sao cho chỉ báo lỗi khóa ngoại

INSERT INTO NHANVIEN VALUES (N'Nguyễn', N'Thanh', N'Trúc', '010', '1/1/2000', N'200 Cống Quỳnh Q1,TP HCM',N'Nữ',40000, '011', 4)

--Câu 2 b ii)Sửa lệnh trên sao cho không báo lỗi

INSERT INTO NHANVIEN VALUES (N'Nguyễn', N'Thanh', N'Trúc', '005', '1/1/2000', N'200 Cống Quỳnh Q1,TP HCM',N'Nữ',40000, '004', 4)

--Câu 3)Phái của NHANVIEN phải là “Nam” hoặc “Nữ” (Sử dụng Check)
ALTER TABLE NHANVIEN
ADD CONSTRAINT C_NHANVIEN CHECK (PHAI = N'Nam' OR PHAI = N'Nữ')

--Câu 4)Tạo bảng DEAN có khóa chính, sau đó ràng buộc Tên đề án là duy nhất (Ràng buộc Unique)
ALTER TABLE DEAN
ADD CONSTRAINT U_DEAN UNIQUE (TENDA)

--Câu 5)Bổ sung thuộc tính ngày vào làm (NGAYVAOLAM) cho bảng NHANVIEN, có
--giá trị mặc định là ngày hiện hành, sau đó thêm 1 dòng vào bảng không có giá trị
--ngày vào làm, và 1 dòng có ngày vào làm, xem kết quả (câu này không kiểm tra
--phát sinh lỗi)
ALTER TABLE NHANVIEN
ADD NGAYVAOLAM DATE

UPDATE NHANVIEN SET NGAYVAOLAM = GETDATE()

INSERT INTO NHANVIEN VALUES (N'Nguyễn', N'Thanh', N'Trúc', '007', '1/1/2000', N'200 Cống Quỳnh Q1,TP HCM',N'Nữ',40000, '004', 4,NULL)
INSERT INTO NHANVIEN VALUES (N'Nguyễn', N'Thanh', N'Trúc', '008', '1/1/2000', N'200 Cống Quỳnh Q1,TP HCM',N'Nữ',40000, '004', 4,'1/1/2018')

--Câu 6)Nhân viên có Ngày sinh phải nhỏ hơn ngày vào làm
ALTER TABLE NHANVIEN
ADD CONSTRAINT C_NHANVIEN_2 CHECK(NGSINH < NGAYVAOLAM)

--Câu 7)Cài đặt rule giá trị >0, sau đó gán rule cho thuộc tính mã phòng
CREATE RULE GIATRIDUONG
AS @giatri>0

EXEC SP_BINDRULE'GIATRIDUONG','NHANVIEN.PHG'

--Câu 8)Tạo rule tuổi >= 18 tuổi, gán rule cho ngày sinh của nhân viên
CREATE RULE TUOI
AS GETDATE()-@tuoi>=18
EXEC sp_bindrule 'TUOI','NHANVIEN.NGSINH'
INSERT INTO NHANVIEN VALUES (N'Nguyễn', N'Thanh', N'Trúc', '011', '12/31/2002', N'200 Cống Quỳnh Q1,TP HCM',N'Nữ',40000, '004', 4,NULL)

--Câu 9)Vô hiệu hóa ràng buộc rule giá trị >0
exec sp_unbindrule 'NHANVIEN.PHG'

--Câu 10)Mở lại ràng buộc câu rule giá trị >0
exec sp_bindrule 'GIATRIDUONG','NHANVIEN.PHG'

--Câu 11)Xóa rule giá trị >0
exec sp_unbindrule 'NHANVIEN.PHG'
DROP RULE GIATRIDUONG

--Câu 12)Xóa ràng buộc ngày sinh phải nhỏ hơn ngày vào làm
ALTER TABLE NHANVIEN DROP CONSTRAINT C_NHANVIEN_2

--Câu 13)Vô hiệu hóa khóa ngoại của bảng nhân viên
ALTER TABLE NHANVIEN NOCHECK CONSTRAINT FK_NHANVIEN, FK_NHANVIEN_2

--Câu 14)Mở lại ràng buộc khóa ngoại của bảng nhân viên
ALTER TABLE NHANVIEN CHECK CONSTRAINT FK_NHANVIEN, FK_NHANVIEN_2

--Câu 15)Vô hiệu hóa ràng buộc khóa chính của bảng nhân viên
ALTER INDEX PK__NHANVIEN__603F51141BA4624B ON NHANVIEN
DISABLE;

--Câu 16)Mở lại hiệu hóa ràng buộc khóa chính của bảng nhân viên
ALTER INDEX PK__NHANVIEN__603F51141BA4624B ON NHANVIEN
REBUILD;


-------------------BTVN--------------------


CREATE DATABASE [QUANLYSINHVIEN] ON PRIMARY
(
    NAME = QUANLYSINHVIEN_MDF,
    FILENAME='D:\BTTO\DATABASE\TUAN_3_BTVN\QUANLYSINHVIEN.MDF',
    SIZE = 20MB,MAXSIZE=2GB,FILEGROWTH=10%
)
LOG ON(
    NAME = QUANLYSINHVIEN_LOG,
    FILENAME = 'D:\BTTO\DATABASE\TUAN_3_BTVN\QUANLYSINHVIEN_LOG.LOG',
    SIZE = 10MB , MAXSIZE=1gb,FILEGROWTH=5mb
)

CREATE TABLE GIAOVIEN (
    magv char(9),
    tengv nvarchar(15),
    makhoa varchar(9),
    primary key (magv)
)

CREATE TABLE PHANCONG (
    magv char(9),
    malop varchar(9),
    mamh varchar(9),
    nam int,
    hocky int,
    primary key (magv,malop,mamh,nam,hocky)
)
CREATE TABLE KETQUAHOC (
    mamh varchar(9),
    masv char(9),
    nam int,
    hocky int,
    lanthi int,
    diem int,
    magv char(9),
    malop varchar(9),
    primary key (mamh,masv,nam,hocky,lanthi,magv,malop)
)
CREATE TABLE MONHOC (
    mamh varchar(9),
    tenmh nvarchar(15),
    sotinchi int,
    primary key (mamh)
)

CREATE TABLE LOPHOC (
    malop varchar(9),
    tenlop nvarchar(20),
    siso int,
    makhoa varchar(9),
    primary key (malop)
)



CREATE TABLE KHOA (
    makhoa varchar(9),
    tenkhoa nvarchar(20),
    namTL int,
    primary key (makhoa)

)

CREATE TABLE SINHVIEN (
    masv char(9),
    hosv nvarchar(15),
    tenlot nvarchar(15),
    tensv nvarchar(15),
    diachi nvarchar(50),
    sdt char(15),
    ngaysinh date,
    malop varchar(9),
    primary key (masv)
)
--1. Viết lệnh tạo bảng sinh viên có khóa chính và khóa ngoại.
ALTER TABLE PHANCONG ADD CONSTRAINT FK_PHANCONG_GIAOVIEN FOREIGN KEY (magv) REFERENCES GIAOVIEN(magv)
ALTER TABLE PHANCONG ADD CONSTRAINT FK_PHANCONG_MONHOC FOREIGN KEY (mamh) REFERENCES MONHOC(mamh)
ALTER TABLE PHANCONG ADD CONSTRAINT FK_PHANCONG_LOPHOC FOREIGN KEY (malop) REFERENCES LOPHOC(malop)
ALTER TABLE SINHVIEN ADD CONSTRAINT FK_SINHVIEN_LOPHOC FOREIGN KEY (malop) REFERENCES LOPHOC(malop)
ALTER TABLE LOPHOC ADD CONSTRAINT FK_LOPHOC_KHOA FOREIGN KEY (makhoa) REFERENCES KHOA(makhoa)
ALTER TABLE KETQUAHOC ADD CONSTRAINT FK_KETQUAHOC_SINHVIEN FOREIGN KEY (masv) REFERENCES SINHVIEN(masv)
ALTER TABLE KETQUAHOC ADD CONSTRAINT FK_KETQUAHOC_PHANCONG FOREIGN KEY (magv,malop,mamh,nam,hocky) REFERENCES PHANCONG(magv,malop,mamh,nam,hocky)
--2. Thêm ràng buộc sỉ số >= 45
ALTER TABLE LOPHOC
    ADD CHECK (siso>=45)
--3. Thêm ràng buộc tên lớp là duy nhất
ALTER TABLE lophoc
    ADD CONSTRAINT U_lophoc
        UNIQUE (tenlop)
--4. Tạo rule ngày nhập > ngày hiện tại, gán rule cho ngày sinh của sinh viên
CREATE RULE NGAYNHAP
    AS @lonhonngaynhap>GETDATE()

EXEC sp_bindrule 'NGAYNHAP','SINHVIEN.ngaysinh'
--5. Ràng buộc sinh viên có tuổi <=35
ALTER TABLE SINHVIEN
    ADD CHECK( (YEAR(GETDATE()) - YEAR(ngaysinh)) <= 35 );

--6. Thêm cột ngày nhập học vào bảng sinh viên và cho giá trị mặc định là ‘5/9/2020’
ALTER TABLE SINHVIEN
ADD ngaynhaphoc date NOT NULL
ALTER TABLE SINHVIEN
ADD CONSTRAINT D_SINHVIEN DEFAULT '05/09/2020' FOR ngaynhaphoc

--7. nhập bảng sinh viên với ít nhất 10 dòng với yêu cầu sau:
EXEC sp_unbindrule 'SINHVIEN.ngaysinh'

ALTER TABLE SINHVIEN
NOCHECK CONSTRAINT FK_SINHVIEN_LOPHOC

SET DATEFORMAT DMY

INSERT INTO SINHVIEN VALUES('1',N'Phạm',N'Quốc',N'Việt',N'Tiền Giang',0335236853,'19/05/2002','cdth20e',N'05/09/2020')
INSERT INTO SINHVIEN VALUES('2',N'Nguyễn',N'Minh',N'Quân',N'Tây Ninh',0389730266,'12/06/2002','cdth20e',N'05/09/2020')
INSERT INTO SINHVIEN VALUES('3',N'Nguyễn',N'Hoài',N'Phong',N'Tiền Giang',0389730265,'05/12/2002','cdth20e',N'05/09/2020')
INSERT INTO SINHVIEN VALUES('4',N'Trần',N'Thới',N'Long',N'Đồng Tháp',0389730266,'04/11/2002','cdth20e',N'05/09/2020')
INSERT INTO SINHVIEN VALUES('5',N'Nguyễn',N'Thanh',N'Phong',N'Hà Nội',0389730267,'12/12/2002','cdth20e',N'05/09/2020')
INSERT INTO SINHVIEN VALUES('6',N'Nguyễn',N'Thanh',N'Nhã',N'Tiền Giang',0389730268,'11/11/2002','cdth20e',N'05/09/2020')
INSERT INTO SINHVIEN VALUES('7',N'Nguyễn',N'Thái',N'Bảo',N'Bình Định',0389730269,'01/06/2002','cdth20e',N'05/09/2020')
INSERT INTO SINHVIEN VALUES('8',N'Đồng',N'Ngọc',N'Huy',N'Đồng Nai',0389730212,'06/01/2002','cdth20e',N'05/09/2020')
INSERT INTO SINHVIEN VALUES('9',N'Nguyễn',N'Hoà',N'Đồng',N'Tiền Giang',0389730212,'01/01/2002','cdth20e',N'05/09/2020')
INSERT INTO SINHVIEN VALUES('10',N'Hồ',N'Khánh',N'Duy',N'Bến Tre',0389730215,'15/02/2002','cdth20e',N'05/09/2020')

--sắp theo tên tăng dần 
SELECT * INTO SAPXEPSV
FROM SINHVIEN 
ORDER BY tenlot,hosv,ngaysinh DESC
