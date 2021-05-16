create database condition_02_code_27

use condition_02_code_27

create table SACH(
	MaSach char(10) primary key,
	TenSach nvarchar(50),
	SoTrang int,
	SLTon int
)

create table PHIEUMUON(
	MaPM char(10) primary key,
	NgayM date,
	HoTenDG nvarchar(50)
)

create table SACHMUON(
	MaPM char(10),
	MaSach char(10),
	SoNgayMuon int,
	constraint PK_SACHMUON primary key (MaPM, MaSach),
	constraint FK_SACHMUON_01 foreign key (MaSach) references SACH(MaSach) on update cascade on delete cascade,
	constraint FK_SACHMUON_02 foreign key (MaPM) references PHIEUMUON(MaPM) on update cascade on delete cascade
)

insert into SACH values ('S01', 'Sach 01', 200, 100)
insert into SACH values ('S02', 'Sach 02', 200, 100)

insert into PHIEUMUON values ('PM01', '05/10/2021', 'Doc Gia 01')
insert into PHIEUMUON values ('PM02', '05/05/2021', 'Doc Gia 02')

insert into SACHMUON values ('PM01', 'S01', 3)
insert into SACHMUON values ('PM01', 'S02', 10)
insert into SACHMUON values ('PM02', 'S01', 5)

select * from SACH
select * from PHIEUMUON
select * from SACHMUON



-- cau 02: 
alter procedure cau2(@ngay int, @thang int, @nam int)
as
	begin
		declare @tongSoSach int
		declare @ngayNhapChar varchar(10) 
		declare @ngayNhap date
		select @ngayNhapChar = CONCAT(@thang, '/', @ngay, '/', @nam)
		select @ngayNhap = convert(date, @ngayNhapChar, 101)
		select @tongSoSach = COUNT (SACHMUON.MaSach)
		from SACHMUON inner join PHIEUMUON on SACHMUON.MaPM = PHIEUMUON.MaPM
		where DATEADD(DAY, SoNgayMuon, NgayM) < @ngayNhap
		print @tongSoSach
	end

select * from PHIEUMUON
select * from SACHMUON
execute cau2 10, 05, 2021 -- không có dòng nào quá hạn
execute cau2 11, 05, 2021 -- PM02 x S01 quá hạn
execute cau2 14, 05, 2021 -- có 2 dòng quá hạn: PM01 x S01 và PM02 x S02
execute cau2 25, 05, 2021 -- cả 3 dòng quá hạn


-- cau 03:
create trigger cau03 on SACHMUON
for insert
as
	begin
		declare @soNgayMuon int
		declare @maSach char(10)
		select @soNgayMuon = SoNgayMuon, @maSach = MaSach from SACHMUON
		if (@soNgayMuon <= 4)
			begin
				raiserror(N'Số ngày mượn phải > 4.', 16, 1)
				rollback transaction
			end
		else 
			update SACH set SLTon = SLTon - 1 where MaSach = @maSach
	end


select * from SACH
select * from PHIEUMUON
select * from SACHMUON
--insert into SACHMUON values ('PM02', 'S02', 3) --Số ngày mượn không hợp lệ
insert into SACHMUON values ('PM02', 'S02', 6) --Số ngày mượn hợp lệ
select * from SACH
select * from PHIEUMUON
select * from SACHMUON






























