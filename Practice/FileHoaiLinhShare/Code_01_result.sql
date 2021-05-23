create database FileHoaiLinhShare_Code01

use FileHoaiLinhShare_Code01

create table VATTU(
	MaVT char(10) primary key,
	TenVT nvarchar(50),
	DVTinh nvarchar(50),
	SLCon int
)

create table HOADON(
	MaHD char(10) primary key,
	NgayLap date,
	HoTenKhach nvarchar(50)
)

create table CTHOADON(
	MaHD char(10),
	MaVT char(10),
	DonGiaBan money,
	SLBan int,
	constraint PK_CTHOADON primary key (MaHD, MaVT),
	constraint FK_CTHOADON_01 foreign key (MaHD) references HOADON(MaHD) on update cascade on delete cascade,
	constraint FK_CTHOADON_02 foreign key (MaVT) references VATTU(MaVT) on update cascade on delete cascade
)


insert into VATTU values ('VT01', 'Vat tu 01', 'cai', 100)
insert into VATTU values ('VT02', 'Vat tu 02', 'cai', 100)
insert into VATTU values ('VT03', 'Vat tu 03', 'cai', 100)

insert into HOADON values ('HD01', '10/15/2020', 'Khach 01')
insert into HOADON values ('HD02', '03/27/2021', 'Khach 01')
insert into HOADON values ('HD03', '04/17/2021', 'Khach 01')
insert into HOADON values ('HD04', '10/15/2020', 'Khach 04') -- thêm để test :v

--drop table CTHOADON
insert into CTHOADON values ('HD01', 'VT01', 10000, 15)
insert into CTHOADON values ('HD01', 'VT02', 15000, 5)
insert into CTHOADON values ('HD01', 'VT03', 20000, 20)
insert into CTHOADON values ('HD02', 'VT01', 5000, 8)
insert into CTHOADON values ('HD03', 'VT03', 10000, 10)
insert into CTHOADON values ('HD04', 'VT01', 8000, 5) -- thêm để test :v

select * from VATTU
select * from HOADON
select * from CTHOADON

-- cau 02:
create function cau02(@tenVatTu nvarchar(50), @ngayBan date)
returns int
as
	begin
		declare @tienBanHang int
		select @tienBanHang = SUM(SLBan * DonGiaBan)
		from CTHOADON inner join VATTU on VATTU.MaVT = CTHOADON.MaVT
		inner join HOADON on HOADON.MaHD = CTHOADON.MaHD
		where TenVT = @tenVatTu and @ngayBan = NgayLap
		return @tienBanHang
	end

select * from VATTU
select * from HOADON
select * from CTHOADON
select dbo.cau02('Vat tu 01', '10/15/2020') as TienBanHang
select dbo.cau02('Vat tu 01', '03/27/2020') as TienBanHang

-- cau 03:
alter procedure cau03(@thang int, @nam int)
as
	begin
		declare @countVatTu int
		select @countVatTu = SUM(SLBan)
		from CTHOADON inner join HOADON on HOADON.MaHD = CTHOADON.MaHD
		where @thang = MONTH(NgayLap) and @nam = YEAR(NgayLap)
		declare @thangVarChar varchar(5), @namVarChar varchar(5), @soLuongVarChar varchar(5)
		set @thangVarChar = convert(varchar(5), @thang)
		set @namVarchar = convert(varchar(5), @nam)
		set @soLuongVarChar = convert(varchar(5), @countVatTu)
		print N'Tổng số lượng vật tư bán trong tháng ' + @thangVarChar + '/' + @namVarChar + ': ' + @soLuongVarChar
	end

select * from HOADON
select * from CTHOADON
execute cau03'10', '2020'
execute cau03'03', '2021'

-- cau 04:
create trigger cau04 on CTHOADON
for delete
as
	begin
		declare @maVatTuDelete char(10), @soLuongBanDelete int
		select @maVatTuDelete = MaVT, @soLuongBanDelete = SLBan from deleted
		if (not exists (select * from CTHOADON))
			begin
				raiserror(N'Không thể xoá dòng cuối cùng của bảng.', 16, 1)
				rollback transaction
			end
		else
			update VATTU set SLCon = SLCon + @soLuongBanDelete where MaVT = @maVatTuDelete
	end

--drop table CTHOADON
--insert into CTHOADON values ('HD01', 'VT01', 10000, 15)


select * from VATTU
select * from CTHOADON
delete CTHOADON where MaHD = 'HD01' and MaVT = 'VT01'
select * from VATTU
select * from CTHOADON