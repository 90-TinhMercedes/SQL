--Câu 1 (4đ): Tạo csdl QLTV gồm 3 bảng sau: 
--+ Sach(Masach,Tensach,sotrang, SLTon)
--+ PM(MaPM,NgayM, HoTenDG)
--+ SachMuon(MaPM,Masach, songaymuon)
--Nhập dữ liệu cho các bảng: 2 sach, 2 PM và 4 SachMuon.


create database QLTV_Slide22

use QLTV_Slide22

create table SACH (
	MaSach char(10) primary key,
	TenSach nvarchar(50),
	SoTrang int,
	SoLuongTon int
)

create table PHIEUMUON (
	MaPM char(10) primary key,
	NgayMuon date,
	HoTenDocGia nvarchar(50)
)

create table SACHMUON (
	MaPM char(10),
	MaSach char(10),
	SoNgayMuon int,
	constraint PK_SACHMUON primary key (MaPM, MaSach),
	constraint FK_SACHMUON_01 foreign key (MaPM) references PHIEUMUON(MaPM) on update cascade on delete cascade,
	constraint FK_SACHMUON_02 foreign key (MaSach) references SACH(MaSach) on update cascade on delete cascade
)

--drop table SACHMUON
--drop table PHIEUMUON

insert into SACH values ('S01', 'Sach 01', 200, 200)
insert into SACH values ('S02', 'Sach 02', 200, 200)
insert into SACH values ('S03', 'Sach 03', 200, 200)

insert into PHIEUMUON values ('PM01', '04/06/2021', 'Doc gia 01')
insert into PHIEUMUON values ('PM02', '03/15/2021', 'Doc gia 02')
insert into PHIEUMUON values ('PM03', '04/05/2021', 'Doc gia 03')

insert into SACHMUON values ('PM01', 'S01', 15)
insert into SACHMUON values ('PM01', 'S02', 20)
insert into SACHMUON values ('PM02', 'S01', 25)
insert into SACHMUON values ('PM03', 'S01', 5)
insert into SACHMUON values ('PM03', 'S02', 11)

select * from SACH
select * from PHIEUMUON
select * from SACHMUON

--Câu 2 (2đ): Đưa ra danh sách các sách mượn quá hạn.

declare @ngayHomNay date
set @ngayHomNay = GETDATE()
select SACHMUON.MaPM, MaSach, SoNgayMuon, NgayMuon, DATEADD(DAY, SoNgayMuon, NgayMuon) as Deadline
from PHIEUMUON inner join SACHMUON on PHIEUMUON.MaPM = SACHMUON.MaPM
where @ngayHomNay > (select DATEADD(DAY, SoNgayMuon, NgayMuon))

--Câu 3 (2đ): Hãy tạo hàm in ra tên sách chưa được mượn lần nào? (Với tham số vào là: mã sách). 
alter function cau03 (@maSach char(10))
returns nvarchar(50)
as
	begin
		declare @tenSach nvarchar(50)
		--declare @tenSachChuaMuonLanNao nvarchar(50)
		select @tenSach = TenSach from SACH where MaSach = @maSach
		if (@tenSach not in  (select TenSach from SACH inner join SACHMUON on SACH.MaSach = SACHMUON.MaSach))
			begin
				select @tenSach = @tenSach
			end
		else
			begin
				set @tenSach = NULL
				select @tenSach = @tenSach
			end
		return @tenSach
	end

select * from SACH
select * from PHIEUMUON
select * from SACHMUON
select dbo.cau03('S01') as SachChuaDuocMuonLanNao
select dbo.cau03('S02') as SachChuaDuocMuonLanNao
select dbo.cau03('S03') as SachChuaDuocMuonLanNao






