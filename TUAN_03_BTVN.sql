create database [QUANLYSV] on primary
(
    name = QuanLy_mdf,
    filename='D:\0306201461_tuan_3\QuanLy_mdf.mdf',
    size = 20MB,MAXSIZE=2GB,FILEGROWTH=10%
)
log on(
    name = QuanLy_log,
    filename = 'D:\0306201461_tuan_3\QuanLy_log.log',
    size = 10MB , Maxsize=1gb,filegrowth=5mb
)

create table giaovien (
    magv char(9),
    tengv nvarchar(15),
    makhoa varchar(9),
    primary key (magv)
)

create table phancong (
    magv char(9),
    malop varchar(9),
    mamh varchar(9),
    nam int,
    hocky int,
    primary key (magv,malop,mamh,nam,hocky)
)
create table ketquahoc (
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
create table monhoc (
    mamh varchar(9),
    tenmh nvarchar(15),
    sotinchi int,
    primary key (mamh)
)

create table lophoc (
    malop varchar(9),
    tenlop nvarchar(20),
    siso int,
    makhoa varchar(9),
    primary key (malop)
)



create table khoa (
    makhoa varchar(9),
    tenkhoa nvarchar(20),
    namTL int,
    primary key (makhoa)

)

create table sinhvien (
    masv char(9),
    hosv nvarchar(15),
    tenlot nvarchar(15),
    tensv nvarchar(15),
    diachi nvarchar(50),
    sdt char(10),
    ngaysinh date,
    malop varchar(9),
    primary key (masv)
)
--1. Viết lệnh tạo bảng sinh viên có khóa chính và khóa ngoại.
alter table phancong
    add constraint FK_phancong_giaovien
        foreign key (magv)
            references giaovien(magv)

alter table phancong
    add constraint FK_phancong_monhoc
        foreign key (mamh)
            references monhoc(mamh)

alter table phancong
    add constraint FK_phancong_lophoc
        foreign key (malop)
            references lophoc(malop)
--

alter table sinhvien 
    add constraint FK_sinhvien_lophoc
        foreign key (malop)
            references lophoc(malop)

alter table lophoc
    add constraint FK_lophoc_khoa
        foreign key (makhoa)
            references khoa(makhoa)

alter table ketquahoc
    add constraint FK_ketquahoc_sinhvien
        foreign key (masv)
            references sinhvien(masv)

alter table ketquahoc
    add constraint FK_ketquahoc_phancong
        foreign key (magv,malop,mamh,nam,hocky)
            references phancong(magv,malop,mamh,nam,hocky)
--2. Thêm ràng buộc sỉ số >= 45
alter table lophoc
    add check (siso>=45)
--3. Thêm ràng buộc tên lớp là duy nhất
alter table lophoc
    add constraint U_lophoc
        unique (tenlop)
--4. Tạo rule ngày nhập > ngày hiện tại, gán rule cho ngày sinh của sinh viên
create rule ngaynhap
    as @lonhonngaynhap>getdate()

exec sp_bindrule 'ngaynhap','sinhvien.ngaysinh'
--5. Ràng buộc sinh viên có tuổi <=35
alter table sinhvien
    add check( ((getdate()) - (ngaysinh)) <= 35 );

--6. Thêm cột ngày nhập học vào bảng sinh viên và cho giá trị mặc định là ‘5/9/2020’
ALTER TABLE SINHVIEN
ADD ngaynhaphoc date NOT NULL
ALTER TABLE SINHVIEN
ADD DEFAULT '05/09/2020' FOR ngaynhaphoc
