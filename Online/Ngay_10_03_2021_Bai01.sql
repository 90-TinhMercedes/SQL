Create Database QLBenhVien

use QLBenhVien

create table BenhVien (
MaBV char(10) primary key,
TenBV char(30)
)

create table KhoaKham (
MaKhoa char(10) primary key,
TenKhoa char(30),
SoBenhNhan int,
MaBV char(10),
constraint fk_KhoaKham foreign key (MaBV) references BenhVien(MaBV) on update cascade on delete cascade
)

create table BenhNhan(
MaBN char(10) primary key,
HoTen char(30),
NgaySinh datetime,
GioiTinh bit,
SoNgayNV int,
MaKhoa char(10),
constraint fk_BenhNhan foreign key (MaKhoa) references KhoaKham(MaKhoa) on update cascade on delete cascade
)

insert into BenhVien values ('BV01', 'Benh vien 01')
insert into BenhVien values ('BV02', 'Benh vien 02')

insert into KhoaKham values ('K01', 'Khoa San', 5, 'BV01')
insert into KhoaKham values ('K02', 'Khoa Phu San', 8, 'BV01')

insert into BenhNhan values ('BN01', 'Tran Gia', '03/12/1997', 0, 15, 'K01')
insert into BenhNhan values ('BN02', 'Dang My', '03/17/1998', 1, 7, 'K02')
insert into BenhNhan values ('BN03', 'Le Khoa', '06/12/1996', 0, 9, 'K02')
insert into BenhNhan values ('BN04', 'Tran Dung', '09/04/1997', 1, 13, 'K01')
insert into BenhNhan values ('BN05', 'Le Tran', '07/24/1996', 1, 4, 'K01')
insert into BenhNhan values ('BN06', 'Tu Khoi', '12/22/2000', 0, 22, 'K02')
insert into BenhNhan values ('BN07', 'Bach Gia', '05/18/1999', 0, 8, 'K01')

drop table BenhNhan

select * from BenhVien
select * from KhoaKham
select * from BenhNhan

-- Câu 02:
-- cách trên sai, ra hai kết quả cùng tuổi
select MaBN, HoTen, (2021 - year(NgaySinh)) as Tuoi 
from BenhNhan 
where (2021 - year(NgaySinh)) = (select max(2021 - year(NgaySinh)) from BenhNhan)

-- or
-- ra một kết quả lớn nhất
select MaBN, HoTen, Year(GETDATE()) - Year(NgaySinh) as 'Tuoi'
from BenhNhan
Where NgaySinh = (select min(NgaySinh) from BenhNhan)


-- Câu 03:






-- Câu 04
create proc xoaKhoa(@MaKhoa char(10)) 
as
	begin
		if (not exists (select * from KhoaKham where MaKhoa = @MaKhoa))
			print 'Khong ton tai ma khoa can xoa.'
		else
			delete from KhoaKham where MaKhoa = @MaKhoa
	end
-- TEST
select * from BenhVien
select * from KhoaKham
select * from BenhNhan

exec xoaKhoa 'K05'
exec xoaKhoa 'K02'
