create database Bai11_PhieuGiaoBaiTap01

use Bai11_PhieuGiaoBaiTap01

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

--a. Tạo Trigger kiểm soát việc nhập dữ liệu cho bảng nhập, hãy kiểm tra các ràng buộc toàn
--vẹn: MaSP có trong bảng sản phẩm chưa? Kiểm tra các ràng buộc dữ liệu: SoLuongN và
--DonGiaN>0? Sau khi nhập thì SoLuong ở bảng SanPham sẽ được cập nhật theo

alter trigger cauA
on NHAP
for insert
as
	begin
		declare @maSanPham char(10)
		declare @soLuongNhap int
		declare @donGiaNhap money
		select @maSanPham = MaSP, @soLuongNhap = SoLuongNhap, @donGiaNhap = DonGia from inserted
		if (not exists (select * from SANPHAM where MaSP = @maSanPham))
			begin
				raiserror (N'Error: Không tồn tại mã sản phẩm này.', 16, 1)
				rollback transaction
			end
		else
			begin
				if (@soLuongNhap <= 0 or @donGiaNhap <= 0)
					begin
						raiserror (N'Error: Số lượng nhập hoặc Đơn giá nhậo không hợp lệ. TRANSACTION!!', 16, 1)
						rollback transaction
					end
				else
					update SANPHAM set SoLuong = SoLuong + @soLuongNhap from SANPHAM where MaSP = @maSanPham
			end
	end

select * from SANPHAM
select * from PHIEUNHAP
select * from NHAP
--insert into NHAP values ('PN02', 'SP08', 0, 0) --Mã sản phẩm này không tồn tại
--insert into NHAP values ('PN02', 'SP01', 0, 5000) --Lỗi số lượng nhập <= 0
--insert into NHAP values ('PN01', 'SP01', 10, 0) --Lỗi đơn giá nhập <= 0
insert into NHAP values ('PN02', 'SP01', 10, 5000) --Hợp lệ
select * from SANPHAM
select * from PHIEUNHAP
select * from NHAP

--b. Tạo Trigger kiểm soát việc nhập dữ liệu cho bảng xuất, hãy kiểm tra các ràng buộc toàn
--vẹn: MaSP có trong bảng sản phẩm chưa? kiểm tra các ràng buộc dữ liệu: SoLuongX <
--SoLuong trong bảng SanPham? Sau khi xuất thì SoLuong ở bảng SanPham sẽ được cập
--nhật theo.

create trigger cauB
on XUAT
for insert
as
	begin
		declare @maSanPham char(10)
		declare @soLuong int
		declare @soLuongXuat int
		select @maSanPham = MaSP, @soLuongXuat = SoLuongXuat from inserted
		select @soLuong = SoLuong from SANPHAM
		if (not exists (select * from SANPHAM where MaSP = @maSanPham))
			begin
				raiserror (N'Error: Mã sản phẩm này không tồn tại. TRANSACTION!!!', 16, 1)
				rollback transaction
			end
		else
			begin
				if (@soLuong < @soLuongXuat)
					begin
						raiserror (N'Error: Không đủ số lượng sản phẩm để xuất. TRANSACTION!!', 16, 1)
						rollback transaction
					end
				else
					update SANPHAM set SoLuong = SoLuong - @soLuongXuat where MaSP = @maSanPham
			end
	end

select * from SANPHAM
select * from PHIEUXUAT
select * from XUAT
--insert into XUAT values ('PX02', 'SP08', 150) --Mã sản phẩm này không tồn tại
--insert into XUAT values ('PX02', 'SP01', 1000) --Lỗi số lượng trong kho < Số lượng xuất. Không đủ hàng
insert into XUAT values ('PX01', 'SP01', 10) --Hợp lệ
select * from SANPHAM
select * from PHIEUXUAT
select * from XUAT

--c. Tạo Trigger kiểm soát việc xóa phiếu xuất, khi phiếu xuất xóa thì số lượng hàng trong
--bảng SanPham sẽ được cập nhật tăng lên

create trigger cauC
on XUAT
for delete
as
	begin
		declare @maSanPhamXuat char(10)
		declare @soLuongXuat int
		select @maSanPhamXuat = MaSP, @soLuongXuat = SoLuongXuat from deleted
		update SANPHAM set SoLuong = SoLuong + @soLuongXuat where MaSP = @maSanPhamXuat
	end

drop trigger cauC

select * from SANPHAM
select * from PHIEUXUAT
select * from XUAT
delete from PHIEUXUAT where SoHDX = 'PX01'
select * from SANPHAM
select * from PHIEUXUAT
select * from XUAT













