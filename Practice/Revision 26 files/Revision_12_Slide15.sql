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

--Câu 2(2đ): Đưa ra những bệnh nhân có tuổi cao nhất gồm: MaBN, HoTen, Tuổi.

select MaBN, HoTen, MAX(YEAR(GETDATE()) - YEAR(NgaySinh)) as Tuoi
from BENHNHAN
where (YEAR(GETDATE()) - YEAR(NgaySinh)) = (select MAX(YEAR(GETDATE()) - YEAR(NgaySinh)) from BENHNHAN)
group by MaBN, HoTen
 
--Câu 3(2đ): Viết hàm với tham số truyền vào là MaBN, hàm trả về một bảng 
--gồm các thông tin:MaBN, HoTen, NgaySinh, GioiTinh (là “Nam“ hoặc “Nữ“), TenKhoa, TenBV.

create procedure cau3 (@maBenhNhan char(10))
as
	begin
		select MaBN, HoTen, NgaySinh, case GioiTinh
		when 0 then 'Female'
		when 1 then 'Male' end as GioiTinh
		from BENHNHAN
		where MaBN = @maBenhNhan
	end

select * from BENHVIEN
select * from KHOAKHAM
select * from BENHNHAN
execute cau3 'BN02'
execute cau3 'BN03'
execute cau3 'BN05'



--Câu 3_2 (2đ): Hãy tạo thủ tục lưu trữ in ra tổng số tiền thu được của từng khoa khám bệnh 
--là bao nhiêu?(Với tham số vào là: MaKhoa, Tien=SoNgayNV*80000).

create procedure cau3_2 (@maKhoa char(15))
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
execute cau3_2 'K01'
execute cau3_2 'K02'
execute cau3_2 'K03'


--Câu 4 (3đ): Hãy tạo Trigger để tự động tăng số bệnh nhân trong bảng KhoaKham, 
--mỗi khi thêm mới dữ liệu cho bảng BenhNhan. Nếu số bệnh nhân 
--trong 1 khoa khám > 6 thì không cho thêm và đưa ra cảnh báo

create trigger cau4
on BENHNHAN
for insert
as
	begin
		declare @soBenhNhanHienTai int
		declare @maKhoaThemBenhNhan char(10)
		select @maKhoaThemBenhNhan = MaKhoa from inserted
		select @soBenhNhanHienTai = SoBenhNhan from KHOAKHAM
		where MaKhoa = @maKhoaThemBenhNhan
		if (@soBenhNhanHienTai > 6)
			begin
				raiserror (N'Error: Khoa đã có nhiều hơn 6 bệnh nhân, không thể thêm.', 16, 1)
				rollback transaction 
			end
		else
			update KHOAKHAM set SoBenhNhan = SoBenhNhan + 1 where MaKhoa = @maKhoaThemBenhNhan
	end

select * from BENHVIEN
select * from KHOAKHAM
select * from BENHNHAN
insert into BENHNHAN values ('BN06', 'Draven', '04/12/1992', 1, 6, 'K02') -- Khoa 02 có số bệnh nhân hiện tại: 8. Không thể thêm
insert into BENHNHAN values ('BN07', 'Aatrox', '06/25/1992', 1, 3, 'K03') -- Khoa 03 có số bệnh nhân hiện tại: 6. Có thể thêm
insert into BENHNHAN values ('BN08', 'Renekton', '08/17/1991', 0, 5, 'K03') -- Khoa 03 có số bệnh nhân hiện tại: 7. Không thể thêm






