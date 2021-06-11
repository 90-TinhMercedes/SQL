-- BÀI LÀM
-- câu 01:
-- a,
create database QLThuVien

use QLThuVien 

create table DOCGIA (
	MaDG char(10) primary key,
	TenDG nvarchar(50),
	DiaChi nvarchar(50),
	SoDT nvarchar(50)
)


create table SACH (
	MaS char(10) primary key,
	TenS nvarchar(50),
	SoLuong int,
	NhaXB nvarchar(50),
	NamXB int
)

create table PHIEUMUON (
	MaPM char(10) primary key,
	MaS char(10),
	MaDG char(10),
	SoLuongMuon int,
	NgayM date,
	constraint fk_PHIEUMUON_01 foreign key (MaS) references SACH(MaS) on update cascade on delete cascade,
	constraint fk_PHIEUMUON_02 foreign key (MaDG) references DOCGIA(MaDG) on update cascade on delete cascade
)

--b,

insert into DOCGIA values ('DG01', 'Doc gia 01', 'Dia chi 01', '089898989')
insert into DOCGIA values ('DG02', 'Doc gia 02', 'Dia chi 02', '045454545')
insert into DOCGIA values ('DG03', 'Doc gia 03', 'Dia chi 03', '056565656')

insert into SACH values ('SA01', 'Sach 01', 200, 'Nha xuat ban 01', 2020)
insert into SACH values ('SA02', 'Sach 02', 150, 'Nha xuat ban 02', 2021)
insert into SACH values ('SA03', 'Sach 03', 100, 'Nha xuat ban 03', 2019)

insert into PHIEUMUON values ('PM01', 'SA01', 'DG01', 5, '08/17/2020')
insert into PHIEUMUON values ('PM02', 'SA02', 'DG02', 10, '05/28/2020')
insert into PHIEUMUON values ('PM03', 'SA02', 'DG03', 5, '06/27/2020')
insert into PHIEUMUON values ('PM04', 'SA01', 'DG01', 15, '11/16/2019')
insert into PHIEUMUON values ('PM05', 'SA03', 'DG02', 20, '08/17/2020')

select * from DOCGIA
select * from SACH
select * from PHIEUMUON

-- câu 02:
create function cau02(@maDocGia char(10))
returns int
as
	begin
		declare @tongSoLuongMuon int
		select @tongSoLuongMuon = SUM(SoLuongMuon) from PHIEUMUON where MaDG = @maDocGia
		return @tongSoLuongMuon
	end

select * from PHIEUMUON
select dbo.cau02('DG01') as TongSoLuong -- Độc giả có mã DG01 mượn 20 quyển
select dbo.cau02('DG02') as TongSoLuong -- Độc giả có mã DG02 mượn 30 quyển

-- câu 03:
create procedure cau03(@maPM char(10), @tenSach nvarchar(50), @tenDocGia nvarchar(50), @soLuongM int, @ngayM date)
as
	begin
		declare @maSachMuon char(10), @maDocGiaMuon char(10)
		if (not exists (select * from SACH where TenS = @tenSach) or not exists (select * from DOCGIA where TenDG = @tenDocGia))
			begin
				print N'Không tồn tại tên sách hoặc không tồn tại tên độc giả, không thể thêm PHIEUMUON mới.'
			end
		else
			begin
				select @maSachMuon = MaS from SACH where TenS = @tenSach
				select @maDocGiaMuon = MaDG from DOCGIA where TenDG = @tenDocGia
				insert into PHIEUMUON values (@maPM, @maSachMuon, @maDocGiaMuon, @soLuongM, @ngayM)
			end
	end

select * from DOCGIA
select * from SACH
select * from PHIEUMUON
--execute cau03 'PM06', 'Sach 100', 'Doc gia 100', 25, '04/25/2020' -- Tên sách và tên độc giả không tồn tại.
--execute cau03 'PM06', 'Sach 100', 'Doc gia 01', 25, '04/25/2020' -- Tên sách hoặc tên độc giả không tồn tại.
execute cau03 'PM06', 'Sach 03', 'Doc gia 03', 25, '04/25/2020' -- Hợp lệ
select * from PHIEUMUON

-- câu 04:
create trigger cau01 on PHIEUMUON for delete
as
	begin
		declare @maSachDelete char(10), @soLuongDelete int
		select @maSachDelete = MaS, @soLuongDelete = SoLuongMuon from deleted
		update SACH set SoLuong = SoLuong + @soLuongDelete where MaS = @maSachDelete
	end

select * from SACH
select * from PHIEUMUON
--delete PHIEUMUON where MaPM = 'PM01' -- Xoá PM01, cập nhật lại số lượng sách có mã SA01: 200 + 5 = 205
delete PHIEUMUON where MaPM = 'PM02' -- Xoá PM02, cập nhật lại số lượng sách có mã SA02: 150 + 10 = 160
select * from SACH
select * from PHIEUMUON


