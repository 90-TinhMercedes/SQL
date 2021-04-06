create database Bai11_PhieuGiaoBaiTap02

use Bai11_PhieuGiaoBaiTap02

create table HANGSX (
	MaHangSX char(10) primary key, 
	TenHang nvarchar(50),
	DiaChi nvarchar(50),
	SDT nvarchar(50),
	Email nvarchar(50)
)

create table SANPHAM (
	MaSP char(10) primary key, 
	MaHangSX char(10), 
	TenSP nvarchar(50),
	SoLuong int,
	MauSac nvarchar(50),
	GiaBan money,
	DonViTinh nvarchar(50),
	MoTa nvarchar(50),
	constraint FK_SANPHAM foreign key (MaHangSX) references HANGSX(MaHangSX) on update cascade on delete cascade
)

create table NHANVIEN (
	MaNV char(10) primary key,
	TenNV nvarchar(50),
	GioiTinh nvarchar(50),
	DiaChi nvarchar(50),
	SDT nvarchar(50),
	Email nvarchar(50),
	TenPhong nvarchar(50)
)

create table PHIEUNHAP (
	SoHDN char(10) primary key,
	NgayNhap date,
	MaNV char(10),
	constraint FK_PHIEUNHAP foreign key (MaNV) references NHANVIEN(MaNV) on update cascade on delete cascade  
)

create table NHAP (
	SoHDN char(10),
	MaSP char(10),
	SoLuongNhap int,
	DonGia money,
	constraint PK_NHAP primary key (SoHDN, MaSP),
	constraint FK_NHAP_01 foreign key (SoHDN) references PHIEUNHAP(SoHDN) on update cascade on delete cascade, 
	constraint FK_NHAP_02 foreign key (MaSP) references SANPHAM(MaSP) on update cascade on delete cascade  
)

create table PHIEUXUAT (
	SoHDX char(10) primary key,
	NgayXuat date,
	MaNV char(10),
	constraint FK_PHIEUXUAT foreign key (MaNV) references NHANVIEN(MaNV) on update cascade on delete cascade  
)

create table XUAT (
	SoHDX char(10),
	MaSP char(10),
	SoLuongXuat int,
	constraint PK_XUAT primary key (SoHDX, MaSP),
	constraint FK_XUAT_01 foreign key (SoHDX) references PHIEUXUAT(SoHDX) on update cascade on delete cascade, 
	constraint FK_XUAT_02 foreign key (MaSP) references SANPHAM(MaSP) on update cascade on delete cascade  
)

insert into HANGSX values('HSX01', 'Hang 01', 'Dia Chi 01', '045454545', 'hang01@gmail.com')
insert into HANGSX values('HSX02', 'Hang 02', 'Dia Chi 02', '045454545', 'hang02@gmail.com')
insert into HANGSX values('HSX03', 'Hang 03', 'Dia Chi 03', '045454545', 'hang03@gmail.com')
insert into HANGSX values('HSX04', 'Hang 04', 'Dia Chi 04', '045454545', 'hang04@gmail.com')
insert into HANGSX values('HSX05', 'Hang 05', 'Dia Chi 05', '045454545', 'hang05@gmail.com')

insert into SANPHAM values('SP01', 'HSX01', 'San Pham 01', 500, '7 mau', 10000, 'cai', 'tinh handsome')
insert into SANPHAM values('SP02', 'HSX02', 'San Pham 02', 200, 'tim', 15000, 'cai', 'tinh handsome')
insert into SANPHAM values('SP03', 'HSX02', 'San Pham 03', 300, '7 mau', 20000, 'chiec', 'tinh handsome')
insert into SANPHAM values('SP04', 'HSX01', 'San Pham 04', 300, 'xanh', 30000, 'cai', 'tinh handsome')
insert into SANPHAM values('SP05', 'HSX01', 'San Pham 05', 400, 'do', 10000, 'chiec', 'tinh handsome')
insert into SANPHAM values('SP06', 'HSX03', 'San Pham 06', 500, 'lam', 15000, 'cai', 'tinh handsome')

insert into NHANVIEN values ('NV01', 'Nhan vien 01', 'Nu', 'Dia chi 01', 'SDT 01', 'nhanvien@gmail.com', 'Phong 01')
insert into NHANVIEN values ('NV02', 'Nhan vien 02', 'Nam', 'Dia chi 02', 'SDT 02', 'nhanvien@gmail.com', 'Phong 02')
insert into NHANVIEN values ('NV03', 'Nhan vien 03', 'Nu', 'Dia chi 03', 'SDT 03', 'nhanvien@gmail.com', 'Phong 03')

insert into PHIEUNHAP values ('PN01', '05/17/2020', 'NV01')
insert into PHIEUNHAP values ('PN02', '05/17/2020', 'NV02')
insert into PHIEUNHAP values ('PN03', '05/17/2020', 'NV01')
insert into PHIEUNHAP values ('PN04', '05/17/2020', 'NV03')

insert into PHIEUXUAT values ('PX01', '06/25/2020', 'NV01')
insert into PHIEUXUAT values ('PX02', '06/25/2020', 'NV02')
insert into PHIEUXUAT values ('PX03', '06/25/2020', 'NV03')
insert into PHIEUXUAT values ('PX04', '06/25/2020', 'NV03')

select * from HANGSX
select * from SANPHAM
select * from NHANVIEN
select * from PHIEUNHAP
select * from PHIEUXUAT

--a. Tạo Trigger cho việc cập nhật lại số lượng xuất trong bảng xuất, hãy kiểm tra xem số
--lượng xuất thay đổi có nhỏ hơn SoLuong trong bảng SanPham hay ko? số bản ghi thay đổi
-->1 bản ghi hay không? nếu thỏa mãn thì cho phép Update bảng xuất và Update lại SoLuong
--trong bảng SanPham.

create trigger cauA
on XUAT
for update
as
	begin
		if (@@rowcount > 1)
			begin
				raiserror (N'Error: Không được phép thực hiện thay đổi nhiều hơn 01 bản ghi. TRANSACTION!!', 16, 1)
				rollback transaction
			end
		else
			begin
				declare @soLuongCo int
				declare @before int
				declare @after int
				declare @maSanPham char(10)
				select @soLuongCo = SoLuong from SANPHAM
				select @before = SoLuongXuat, @maSanPham = MaSP from deleted
				select @after = SoLuongXuat from inserted
				if (@soLuongCo < (@after - @before))
					begin
						raiserror (N'Error: Không đủ hàng trong kho để xuất đơn này. TRANSACTION!!', 16, 1)
						rollback transaction
					end
				else
					update SANPHAM set SoLuong = SoLuong - (@after - @before) where MaSP = @maSanPham
			end
	end

drop trigger cauA

--test
insert into XUAT values ('PX01', 'SP01', 10) --Hợp lệ
insert into XUAT values ('PX02', 'SP01', 10) --Hợp lệ
insert into XUAT values ('PX03', 'SP01', 10) --Hợp lệ
select * from HANGSX
select * from SANPHAM
select * from XUAT
--update XUAT set SoLuongXuat = SoLuongXuat + 5 where MaSP = 'SP01' -- thực hiện thay đổi nhiều hơn 1 dòng. Loại
update XUAT set SoLuongXuat = SoLuongXuat + 5 where SoHDX = 'PX01' -- hợp lệ
update XUAT set SoLuongXuat = SoLuongXuat + 5 where SoHDX = 'PX02' -- hợp lệ
select * from HANGSX
select * from SANPHAM
select * from XUAT

--b. Tạo Trigger cho việc cập nhật lại số lượng Nhập trong bảng Nhập, Hãy kiểm tra xem số
--bản ghi thay đổi >1 bản ghi hay không? nếu thỏa mãn thì cho phép Update bảng Nhập và
--Update lại SoLuong trong bảng SanPham

alter trigger cauB
on NHAP
for update
as
	begin
		if (select count(*) from inserted) > 1
			begin
				raiserror(N'Error: Không được phép thực hiện thay đổi nhiều hơn 01 bản ghi. TRANSACTION!!', 16, 1)
				rollback transaction
			end
		else 
			begin
				declare @soLuongNhap int
				declare @soLuongThuc int
				declare @maSanPham char(10)
				select @soLuongThuc = SoLuongNhap from deleted
				select @soLuongNhap = SoLuongNhap, @maSanPham = MaSP from inserted
				update SANPHAM set SoLuong = SoLuong + (@soLuongNhap - @soLuongThuc) where MaSP = @maSanPham
			end

	end


insert into NHAP values ('PN01', 'SP02', 10, 15000) --Hợp lệ
insert into NHAP values ('PN02', 'SP02', 10, 10000) --Hợp lệ
insert into NHAP values ('PN03', 'SP02', 10, 15000) --Hợp lệ

select * from SANPHAM
select * from PHIEUNHAP
select * from NHAP
--update NHAP set SoLuongNhap = SoLuongNhap + 5 where MaSP = 'SP02' -- thực hiện thay đổi nhiều hơn 1 dòng. Loại
update NHAP set SoLuongNhap = SoLuongNhap + 5 where SoHDN = 'PN02' -- hợp lệ
select * from SANPHAM
select * from PHIEUNHAP
select * from NHAP


--c. Tạo Trigger kiểm soát việc xóa phiếu nhập, khi phiếu nhập xóa thì số lượng hàng trong
--bảng SanPham sẽ được cập nhật giảm xuống.

create trigger cauC
on NHAP
for delete
as
	begin
		declare @maSanPhamXoa char(10)
		declare @soLuongNhap int
		select @maSanPhamXoa = MaSP, @soLuongNhap = SoLuongNhap from deleted
		update SANPHAM set SoLuong = SoLuong - @soLuongNhap where MaSP = @maSanPhamXoa
	end

select * from SANPHAM
select * from PHIEUNHAP
select * from NHAP
delete from NHAP where SoHDN = 'PN01'
select * from SANPHAM
select * from PHIEUNHAP
select * from NHAP


























