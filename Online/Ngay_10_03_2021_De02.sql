Create Database QLThuoc

use QLThuoc

create table NSX(
MaNSX char(10) primary key,
TenNSX nvarchar(30),
DiaChi nvarchar(30),
DT int
)

create table THUOC (
MaThuoc char(10) primary key,
TenThuoc nvarchar(30),
Slco int,
Solo int,
NgaySX datetime,
HanSD int,
MaNSX char(10),
constraint fk_thuoc foreign key (MaNSX) references NSX(MaNSX)
)

create table PN(
SoPN char(10),
MaThuoc char(10),
NgayNhap datetime,
SoLuong int,
DonGia money,
constraint pk_pn primary key (SoPN, MaThuoc),
constraint fk_pn foreign key (MaThuoc) references THUOC(MaThuoc) on update cascade on delete cascade
)

insert into NSX values ('NSX01', 'TinhMercedes 01', 'Ha Noi', 045454545)
insert into NSX values ('NSX02', 'TinhMercedes 02', 'Ha Nam', 0141414)
insert into NSX values ('NSX03', 'TinhMercedes 03', 'Hai Phong', 0232323)

insert into THUOC values ('TH01', 'Panadol 01', 500, 1977, '01/15/2020', 6, 'NSX01')
insert into THUOC values ('TH02', 'Panadol 02', 450, 1950, '05/17/2020', 10, 'NSX03')
insert into THUOC values ('TH03', 'Panadol 03', 600, 1960, '02/09/2020', 18, 'NSX02')
insert into THUOC values ('TH04', 'Panadol 04', 250, 2000, '07/22/2020', 12, 'NSX01')

insert into PN values ('PN01', 'TH01', '05/10/2020', 200, 1500)
insert into PN values ('PN02', 'TH03', '05/10/2021', 200, 1500)
insert into PN values ('PN03', 'TH04', '08/09/2020', 200, 1500)
insert into PN values ('PN04', 'TH01', '05/10/2020', 200, 1500)
insert into PN values ('PN05', 'TH02', '12/07/2020', 200, 1500)
insert into PN values ('PN06', 'TH03', '11/05/2020', 200, 1500)

drop table NSX
drop table THUOC
drop table PN

select * from NSX
select * from THUOC
select * from PN







-- Câu 03:
create proc themNSX (@MaNSX char(10), @TenNSX nvarchar(30), @DiaChi nvarchar(30), @DT int)
as
	begin
		if (exists (select * from NSX where MaNSX = @MaNSX))
			print @MaNSX + ' da ton tai.'
		else
			insert into NSX values(@MaNSX, @TenNSX, @DiaChi, @DT)
	end

--TEST

select * from NSX
select * from THUOC
select * from PN

exec themNSX 'NSX01', 'TinhMercedes Benz 01', 'Binh Phuoc', 045454545
exec themNSX 'NSX04', 'TinhMercedes Benz 01', 'Binh Phuoc', 045454545