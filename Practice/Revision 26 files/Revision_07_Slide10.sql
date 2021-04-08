--Câu 1 (3đ): Tạo csdl QLBenhVien gồm 3 bảng: 
--+ BenhVien(MaBV,TenBV)
--+ KhoaKham(MaKhoa, TenKhoa, SoBenhNhan, MaBV)
--+ BenhNhan(MaBN,HoTen,NgaySinh,GioiTinh(bit),SoNgayNV, MaKhoa)


create database QLBenhVien_Slide10

use QLBenhVien_Slide10

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

--Câu 2 (2đ): Hãy tạo View đưa ra thống kê số bệnh nhân Nữ của từng khoa khám gồm các thông tin: MaKhoa, TenKhoa, Số_người.
create view cau02
as
	select KHOAKHAM.MaKhoa, TenKhoa, count(MaBN) as SoNguoi
	from KHOAKHAM inner join BENHNHAN on KHOAKHAM.MaKhoa = BENHNHAN.MaKhoa
	group by KHOAKHAM.MaKhoa, TenKhoa

select * from cau02

--Câu 3 (2đ): Hãy tạo thủ tục lưu trữ in ra tổng số tiền thu được của từng khoa khám bệnh là bao nhiêu?
--(Với tham số vào là: MaKhoa, Tien=SoNgayNV*80000).

--Làm trước với phần tạo hàm.
alter function cau03_function(@MaKhoa char(10))
returns table
as
	return
		select KHOAKHAM.MaKhoa, sum(SoNgayNV * 80000) as Tien
		from KHOAKHAM inner join BENHNHAN on KHOAKHAM.MaKhoa = BENHNHAN.MaKhoa
		where KHOAKHAM.MaKhoa = @MaKhoa
		group by KHOAKHAM.MaKhoa 

select * from BENHVIEN
select * from KHOAKHAM
select * from BENHNHAN
select * from cau03_function('K01')
select * from cau03_function('K02')

--Câu 3 (2đ): Hãy tạo thủ tục lưu trữ in ra tổng số tiền thu được 
--của từng khoa khám bệnh là bao nhiêu?(Với 
--tham số vào là: MaKhoa, Tien=SoNgayNV*80000).

create procedure cau3 (@maKhoa char(10))
as
	begin
		--declare @tongTien int
		select SUM(SoNgayNV * 80000) as TongTien
		from KHOAKHAM inner join BENHNHAN on KHOAKHAM.MaKhoa = BENHNHAN.MaKhoa
		where @maKhoa = BENHNHAN.MaKhoa
	end


select * from BENHVIEN
select * from KHOAKHAM
select * from BENHNHAN
execute cau3 'K01' 
execute cau3 'K02'

--Câu 4 (3đ): Hãy tạo Trigger để tự động tăng số bệnh nhân trong bảng KhoaKham, 
--mỗi khi thêm mới dữ liệu cho bảng BenhNhan. 
--Nếu số bệnh nhân trong 1 khoa khám > 10 thì không cho thêm và đưa ra cảnh báo

create trigger cau4
on BENHNHAN
for insert
as
	begin
		declare @maKhoaThemBenhNhan char(10)
		declare @soBenhNhanHienCo int
		select @maKhoaThemBenhNhan = MaKhoa from inserted
		select @soBenhNhanHienCo = SoBenhNhan from KHOAKHAM where MaKhoa = @maKhoaThemBenhNhan
		if (@soBenhNhanHienCo >= 10)
			begin
				raiserror (N'Error: Khoa đã có 10 bệnh nhân, không thể nhận thêm.', 16, 1)
				rollback transaction
			end
		else
			update KHOAKHAM set SoBenhNhan = SoBenhNhan + 1 where MaKhoa = @maKhoaThemBenhNhan 
	end

select * from BENHVIEN
select * from KHOAKHAM
select * from BENHNHAN
insert into BENHNHAN values ('BN09', 'Galio', '08/17/1991', 0, 5, 'K02') -- nâng tổng số bệnh nhân khoa 02 lên 09 bệnh nhân
insert into BENHNHAN values ('BN10', 'Samira', '08/17/1991', 0, 5, 'K02') -- nâng tổng số bệnh nhân khoa 02 lên 10 bệnh nhân
insert into BENHNHAN values ('BN11', 'Oriana', '08/17/1991', 0, 5, 'K02') -- Khoa 02 đã có 10 bệnh nhân, không thể thêm
select * from BENHVIEN
select * from KHOAKHAM
select * from BENHNHAN

