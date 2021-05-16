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
		group by NgayM
		print @tongSoSach
	end

select * from PHIEUMUON
select * from SACHMUON
execute cau2 25, 05, 2021
select * from PHIEUMUON
select * from SACHMUON





















