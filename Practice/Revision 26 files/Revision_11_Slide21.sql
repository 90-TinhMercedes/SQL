create database QLTV_Slide21

use QLTV_Slide21

create table SACH (
	MaSach char(10) primary key,
	TenSach nvarchar(50),
	SoTrang int,
	SoLuongTon int
)

create table PHIEUMUON (
	MaPM char(10) primary key,
	NgayMuon datetime,
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

insert into SACH values ('S01', 'Sach 01', 200, 200)
insert into SACH values ('S02', 'Sach 02', 200, 200)
insert into SACH values ('S03', 'Sach 03', 200, 200)

insert into PHIEUMUON values ('PM01', '04/06/2021', 'Doc gia 01')
insert into PHIEUMUON values ('PM02', '03/15/2021', 'Doc gia 02')
insert into PHIEUMUON values ('PM03', '03/21/2021', 'Doc gia 03')

insert into SACHMUON values ('PM01', 'S01', 15)
insert into SACHMUON values ('PM01', 'S02', 20)
insert into SACHMUON values ('PM02', 'S01', 25)
insert into SACHMUON values ('PM03', 'S01', 10)
insert into SACHMUON values ('PM03', 'S02', 5)
insert into SACHMUON values ('PM01', 'S03', 5)
insert into SACHMUON values ('PM02', 'S03', 5)
insert into SACHMUON values ('PM03', 'S03', 5)

select * from SACH
select * from PHIEUMUON
select * from SACHMUON

--Câu 2 (3đ): Hãy tạo hàm in ra tên sách đã được mượn 10 (bài này cho tạm 2 lần trở lên :v) lần trở lên? (Với tham số vào là: mã sách). 
create function cau2(@maSach char(10))
returns nvarchar(50)
as
	begin
		declare @tenSach nvarchar(50)
		select @tenSach = TenSach from SACH inner join SACHMUON on SACH.MaSach = SACHMUON.MaSach
		where SACHMUON.MaSach = @maSach
		group by TenSach
		having COUNT(SACHMUON.MaSach) > 2
		return @tenSach
	end

select * from SACH
select * from PHIEUMUON
select * from SACHMUON
select dbo.cau2('S02') as TenSach -- Sách 02 được mượn 1 lần. Không hợp lệ
select dbo.cau2('S01') as TenSach -- Sách 01 được mượn 3 lần. Hợp lệ
select dbo.cau2('S03') as TenSach -- Sách 03 được mượn 3 lần. Hợp lệ

--Câu 3 (3đ): Hãy tạo trigger để thêm một phiếu mượn. Kiểm tra ngày mượn là ngày hiện tại thì thêm, ngược lại hiện cảnh báo.
create trigger cau3
on PHIEUMUON
for insert 
as
	begin
		declare @day int, @month int, @year int
		select @day = DAY(NgayMuon), @month = MONTH(NgayMuon), @year = YEAR(NgayMuon) from inserted 
		if (@day != DAY(GETDATE()) or @month != MONTH(GETDATE()) or @year != YEAR(GETDATE()) )
			begin
				raiserror (N'Error: Ngày không trùng hôm nay. TRANSACTION!!', 16, 1)
				rollback transaction
			end
	end

--drop table SACHMUON
--drop table PHIEUMUON


select * from SACH
select * from PHIEUMUON
select * from SACHMUON
insert into PHIEUMUON values ('PM04', '03/21/2021', 'Doc gia 04') -- Ngày không trùng hôm nay 06/04/2021. Không hợp lệ
insert into PHIEUMUON values ('PM05', '2021-04-06', 'Doc gia 05') -- Hợp lệ
select * from SACH
select * from PHIEUMUON
select * from SACHMUON



 







