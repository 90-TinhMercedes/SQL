--Câu 1 (3đ): Tạo csdl QLHANG gåm 3 bảng sau: 
--+ VatTu(MaVT, TenVT, DVTinh, SLCon)
--+ HDBan(MaHD, NgayXuat, HoTenKhach)
--+ HangXuat(MaHD,MaVT,DonGia,SLBan)
--Nhập dữ liệu cho các bảng: 2 VatTu, 2 HDBan và 4 HangXuat.


create database QLHANG_Slide14

use QLHANG_Slide14

create table VATTU (
	MaVT char(10) primary key,
	TenVT nvarchar(50),
	DVTinh nvarchar(50),
	SLCon int
)

create table HDBAN (
	MaHD char(10) primary key,
	NgayXuat datetime,
	HoTenKhach nvarchar(50)
)

create table HANGXUAT (
	MaHD char(10),
	MaVT char(10),
	DonGia money,
	SLBan int,
	constraint pk_HANGXUAT primary key (MaHD, MaVT),
	constraint first_fk_HANGXUAT foreign key (MaHD) references HDBAN(MaHD) on update cascade on delete cascade,
	constraint second_fk_HANGXUAT foreign key (MaVT) references VATTU(MaVT) on update cascade on delete cascade
)



insert into VATTU values ('VT01', 'Vat tu 01', 'cai', 200)
insert into VATTU values ('VT02', 'Vat tu 02', 'chiec', 200)

insert into HDBAN values ('HD01', '04/08/2020', 'Tinh Mercedes')
insert into HDBAN values ('HD02', '03/19/2021', 'Tinh Veigar')

insert into HANGXUAT values ('HD01', 'VT01', 15000, 6)
insert into HANGXUAT values ('HD01', 'VT02', 10000, 7)
insert into HANGXUAT values ('HD02', 'VT01', 12000, 10)
insert into HANGXUAT values ('HD02', 'VT02', 21000, 6)

select * from VATTU
select * from HDBAN
select * from HANGXUAT

--Câu 2(2đ): Hãy tạo View đưa ra các hóa đơn xuất vật tư trong năm nay gồm:
--  MaHD, NgayXuat, MaVT, TenVT, ThanhTien (ThanhTien=SLBan*DonGia)

alter view cau2
as
	select HANGXUAT.MaHD, NgayXuat, HANGXUAT.MaVT, TenVT, SUM(SLBan * DonGia) as ThanhTien
	from VATTU inner join HANGXUAT on VATTU.MaVT = HANGXUAT.MaVT
	inner join HDBAN on HDBAN.MaHD = HANGXUAT.MaHD
	where YEAR(NgayXuat) = YEAR(GETDATE())
	group by HANGXUAT.MaHD, NgayXuat, HANGXUAT.MaVT, TenVT

select * from VATTU
select * from HDBAN
select * from HANGXUAT
select * from cau2

--Câu 3(2đ): Viết hàm với tham số truyền vào là MaHD, hàm trả về một bảng gồm các 
--thông tin:MaHD,NgayXuat, MaVT, DonGia, SLBan, NgayThu. Trong đó: 
--Cột NgayThu sẽ là: chủ nhật, thứ hai, ..., thứ bảy (dựa vào giá trị của cột NgayXuat)

create function cau3 (@maHD char(10))
returns table
as
	return
		select HANGXUAT.MaHD, NgayXuat, HANGXUAT.MaVT, DonGia, SLBan, case DATEPART(WEEKDAY, NgayXuat)
		when 1 then 'Sunday'
		when 2 then 'Monday'
		when 3 then 'Tuesday'
		when 4 then 'Wednesday'
		when 5 then 'Thurday'
		when 6 then 'Friday'
		when 7 then 'Saturday' end as NgayThu
		from VATTU inner join HANGXUAT on VATTU.MaVT = HANGXUAT.MaVT
		inner join HDBAN on HDBAN.MaHD = HANGXUAT.MaHD
		where HANGXUAT.MaHD = @maHD

select * from VATTU
select * from HDBAN
select * from HANGXUAT
select * from cau3('HD01')
select * from cau3('HD02')



