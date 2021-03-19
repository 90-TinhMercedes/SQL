--Câu 1 (3đ): Tạo csdl QLHANG gåm 3 bảng sau: 
--+ Hang(MaHang,TenHang,DVTinh, SLTon)
--+ HDBan(MaHD,NgayBan,HoTenKhach)
--+ HangBan(MaHD,MaHang,DonGia,SoLuong)

create database QLHang_Slide11

use QLHang_Slide11

create table HANG (
	MaHang char(10) primary key,
	TenHang nvarchar(50),
	DVTinh nvarchar(50),
	SLTon int
)

create table HDBAN (
	MaHD char(10) primary key,
	NgayBan datetime,
	HoTenKhach nvarchar(50)
)

create table HANGBAN (
	MaHD char(10),
	MaHang char(10),
	DonGia money,
	SoLuong int,
	constraint pk_HANGBAN primary key (MaHD, MaHang),
	constraint first_fk_HangBan foreign key (MaHD) references HDBAN(MaHD) on update cascade on delete cascade,
	constraint second_fk_HangBan foreign key (MaHang) references HANG(MaHang) on update cascade on delete cascade 
)

insert into HANG values ('H01', 'Hang 01', 'cai', 10)
insert into HANG values ('H02', 'Hang 02', 'chiec', 15)

insert into HDBAN values ('HD01', '12/25/2020', 'Tinh Mercedes')
insert into HDBAN values ('HD02', '08/20/2019', 'Tinh Main Veigar')

insert into HANGBAN values ('HD01', 'H01', 15000, 5)
insert into HANGBAN values ('HD02', 'H02', 20000, 4)
insert into HANGBAN values ('HD02', 'H01', 17000, 3)
insert into HANGBAN values ('HD01', 'H02', 9000, 7)

select * from HANG
select * from HDBAN
select * from HANGBAN

--Câu 2 (2đ): Hãy tạo View đưa ra thống kê tiền hàng bán theo từng hóa đơn 
--gồm: MaHD,NgayBan,Tổng tiền (tiền=SoLuong*DonGia)

create view cau02
as
	select HANGBAN.MaHD, NgayBan, sum(SoLuong * DonGia) as TongTien
	from HANGBAN inner join HDBAN on HANGBAN.MaHD = HDBAN.MaHD
	group by HANGBAN.MaHD, NgayBan

select * from cau02

--Câu 3 (2đ): Hãy tạo hàm in ra tổng tiền hàng bán theo năm là bao nhiêu? (Với tham số vào là: Năm).
create function cau03(@Nam int)
returns int
as
	begin
		declare @Result int
		select @Result = sum(SoLuong * DonGia)
		from HDBAN inner join HANGBAN on HDBAN.MaHD = HANGBAN.MaHD
		where YEAR(NgayBan) = @Nam
		return @Result
	end

select  dbo.cau03('2019') as TongTIen
select  dbo.cau03('2020') as TongTIen
select  dbo.cau03('2021') as TongTIen







