create database QLTruongHoc_SupportTuanAnh
go
use QLTruongHoc_SupportTuanAnh
go
create table Khoa(
	Makhoa nvarchar(10) primary key not null,
	Tenkhoa nvarchar(50) not null,
	Dienthoai nvarchar(20)
)
go

create table Lop(
	Malop nvarchar(10) primary key not null,
	Tenlop nvarchar(50) not null,
	Khoa nvarchar(20),
	Hedt nvarchar(20),
	Namnhaphoc int,
	Makhoa nvarchar(10),

	constraint FK_Makhoa foreign key(Makhoa) references Khoa(Makhoa)
)
go

SELECT *FROM KHOA
SELECT *FROM LOP

--Bài tập 1, Viết thủ tục nhập dữ liệu vào bảng KHOA với các tham biến:
--makhoa,tenkhoa, dienthoai, hãy kiểm tra xem tên khoa đã tồn tại trước đó hay chưa,
--nếu đã tồn tại đưa ra thông báo, nếu chưa tồn tại thì nhập vào bảng khoa, test với 2
--trường hợp

Create proc Cau1(@MAkhoa NVARCHAR(10),@TENKHOA NVARCHAR(50),@DIENTHOAI NVARCHAR(20))
AS
   BEGIN
   
        IF(EXISTS (SELECT *FROM KHOA WHERE TENKHOA=@TENKHOA))
	     	BEGIN
               PRINT N'TEN KHOA DA TON TAI'
			END
    	ELSE 
	      BEGIN
	        INSERT INTO KHOA VALUES(@MAkhoa, @TENKHOA, @DIENTHOAI)
	      END
END