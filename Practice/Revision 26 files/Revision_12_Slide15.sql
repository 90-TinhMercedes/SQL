--Câu 1(3đ): Tạo csdl QLBenhVien gồm 3 bảng: 
--+ BenhVien(MaBV,TenBV)
--+ KhoaKham(MaKhoa, TenKhoa, SoBenhNhan, MaBV)
--+ BenhNhan(MaBN,HoTen,NgaySinh,GioiTinh(bit),SoNgayNV, MaKhoa)
--Nhập dữ liệu cho các bảng: 2 Bệnh viện, 2 KhoaKham, 7 BenhNhan. 

create database QLBenhVien_Slide15

use QLBenhVien_Slide15

create table BENHVIEN (
	MaBV char(10) primary key,
	TenBV nvarchar(50)
)

create table KHOAKHAM (
	MaKhoa char(10) primary key,
	TenKhoa nvarchar(50),
	SoBenhNhan int,
	MaBV char(10),
	constraint fk_KHOAKHAM foreign key (MaBV) references BENHVIEN(MaBV) on update cascade on delete cascade
)

create table BENHNHAN (
	MaBN char(10) primary key,
	HoTen nvarchar(50),
	NgaySinh datetime,
	GioiTinh bit,
	SoNgayNV int,
	MaKhoa char(10),
	constraint fk_BENHNHAN foreign key (MaKhoa) references KHOAKHAM(MaKhoa) on update cascade on delete cascade
)

insert into BENHVIEN values ('BV01', 'Benh vien 01')
insert into BENHVIEN values ('BV02', 'Benh vien 02')

insert into KHOAKHAM values ('K01', 'Khoa 01', 5, 'BV01')
insert into KHOAKHAM values ('K02', 'Khoa 02', 8, 'BV01')
insert into KHOAKHAM values ('K03', 'Khoa 03', 6, 'BV02')

-- Bệnh nhân nữ giới tính: bit 0, bệnh nhân nam giới tính: bit 1
insert into BENHNHAN values ('BN01', 'Yasuo', '04/25/1994', 0, 7, 'K01')
insert into BENHNHAN values ('BN02', 'Malphite', '06/05/1995', 1, 5, 'K02')
insert into BENHNHAN values ('BN03', 'Yone', '10/21/1994', 0, 10, 'K03')
insert into BENHNHAN values ('BN04', 'Ashe', '12/17/1993', 0, 15, 'K01')
insert into BENHNHAN values ('BN05', 'Caitlyn', '06/25/1995', 1, 8, 'K01')
insert into BENHNHAN values ('BN06', 'Draven', '04/12/1992', 1, 6, 'K02')
insert into BENHNHAN values ('BN07', 'Aatrox', '06/25/1992', 1, 3, 'K03')
insert into BENHNHAN values ('BN08', 'Renekton', '08/17/1991', 0, 5, 'K01')

select * from BENHVIEN
select * from KHOAKHAM
select * from BENHNHAN

--Câu 2 (2đ): Hãy tạo View đưa ra thống kê số bệnh nhân Nữ 
--của từng khoa khám gồm các thông tin: MaKhoa, TenKhoa, Số_người.
create view cau2
as
	select KHOAKHAM.MaKhoa, TenKhoa, COUNT(MaBN) as SoNguoi
	from KHOAKHAM inner join BENHNHAN on KHOAKHAM.MaKhoa = BENHNHAN.MaKhoa
	where GioiTinh = 0
	group by KHOAKHAM.MaKhoa, TenKhoa

select * from BENHVIEN
select * from KHOAKHAM
select * from BENHNHAN
select * from cau2


--Câu 3 (2đ): Hãy tạo thủ tục lưu trữ in ra tổng số tiền thu được của từng khoa khám bệnh 
--là bao nhiêu?(Với tham số vào là: MaKhoa, Tien=SoNgayNV*80000).

create procedure cau3 (@maKhoa char(15))
as
	begin
		select MaKhoa, SUM(SoNgayNV * 80000) as TongTien
		from BENHNHAN
		where MaKhoa = @maKhoa
		group by MaKhoa
	end

select * from BENHVIEN
select * from KHOAKHAM
select * from BENHNHAN
execute cau3 'K01'










