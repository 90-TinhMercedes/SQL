create database QLBanHang124
go
use QLBanHang124

create table HangSX(
	MaHangSX nchar(10) primary key,
	TenHang nvarchar(20),
	DiaChi nvarchar(30),
	SoDT nvarchar(20),
	Email nvarchar(30)
)

create table SanPham(
	MaSP nchar(10) primary key,
	MaHangSX nchar(10),
	TenSP nvarchar(20),
	SoLuong int,
	MauSac nvarchar(20),
	GiaBan money,
	DonViTinh nchar(10),
	MoTa nvarchar(max)

	constraint FK_MaHangSX foreign key(MaHangSX) references HangSX(MaHangSX)
)

create table NhanVien(
	MaNV nchar(10) primary key,
	TenNV nvarchar(20),
	GioiTinh nchar(10),
	DiaChi nvarchar(30),
	SoDT nvarchar(20),
	Email nvarchar(30),
	TenPhong nvarchar(30)
)

create table PNhap(
	SoHDN nchar(10) primary key,
	NgayNhap date,
	MaNV nchar(10)

	constraint FK_MaNV foreign key(MaNV) references NhanVien(MaNV)
)

create table Nhap(
	SoHDN nchar(10),
	MaSP nchar(10),
	SoLuongN int,
	DonGiaN money

	constraint PK_SoHDN_MaSP primary key(SoHDN, MaSP),
	constraint FK_MaSP foreign key(MaSP) references SanPham(MaSP),
	constraint FK_SoHDN foreign key(SoHDN) references PNhap(SoHDN)
)

create table PXuat(
	SoHDX nchar(10) primary key,
	NgayXuat date,
	MaNV nchar(10)

	constraint FK_MaNV_1 foreign key(MaNV) references NhanVien(MaNV)
)

create table Xuat(
	SoHDX nchar(10),
	MaSP nchar(10),
	SoLuongX int

	constraint PK_SoHDX_MaSP primary key(SoHDX, MaSP),
	constraint FK_MaSP_1 foreign key(MaSP) references SanPham(MaSP),
	constraint FK_SoHDX foreign key(SoHDX) references PXuat(SoHDX)
)

insert into HangSX values(N'H01', N'Samsung', N'Korea', N'011-08271717', N'ss@gmail.com.kr')
insert into HangSX values(N'H02', N'OPPO', N'China', N'081-08626262', N'oppo@gmail.com.cn')
insert into HangSX values(N'H03', N'Vinfone', N'Việt nam', N'084-098262626', N'vf@gmail.com.vn')

--select * from HangSX
insert into NhanVien values(N'NV01',N'Nguyễn Thị Thu',N'Nữ',N'Hà Nội',N'0982626521',N'thu@gmail.com',N'Kế toán')
insert into NhanVien values(N'NV02',N'Lê Văn Nam',N'Nam',N'Bắc Ninh',N'0972525252',N'nam@gmail.com',N'Vật tư')
insert into NhanVien values(N'NV03',N'Trần Hòa Bình',N'Nữ',N'Hà Nội',N'0328388388',N'hb@gmail.com',N'Kế toán')

--select * from NhanVien

insert into SanPham values(N'SP01', N'H02', N'F1 Plus', 100, N'Xám', 7000000, N'Chiếc', N'Hàng cận cao cấp')
insert into SanPham values(N'SP02', N'H01', N'Galaxy Note11', 50, N'Đỏ', 19000000, N'Chiếc', N'Hàng cao cấp')
insert into SanPham values(N'SP03', N'H02', N'F3 lite', 200, N'Nâu', 3000000, N'Chiếc', N'Hàng phổ thông')
insert into SanPham values(N'SP04', N'H03', N'Vjoy3', 200, N'Xám', 1500000, N'Chiếc', N'Hàng phổ thông')
insert into SanPham values(N'SP05', N'H01', N'Galaxy V21', 500, N'Nâu', 8000000, N'Chiếc', N'Hàng cận cao cấp')

--select * from SanPham

insert into PNhap values(N'N01', '2019-2-5', N'NV01')
insert into PNhap values(N'N02', '2020-4-7', N'NV02')
insert into PNhap values(N'N03', '2019-5-17', N'NV02')
insert into PNhap values(N'N04', '2019-3-22', N'NV03')
insert into PNhap values(N'N05', '2019-7-7', N'NV01')

--select * from PNhap

insert into Nhap values(N'N01', N'SP02', 10, 17000000)
insert into Nhap values(N'N02', N'SP01', 30,  6000000)
insert into Nhap values(N'N03', N'SP04', 20, 1200000)
insert into Nhap values(N'N04', N'SP01', 10, 6200000)
insert into Nhap values(N'N05', N'SP05', 20, 7000000)

--select * from Nhap

insert into PXuat values(N'X01', '2020-6-14', N'NV02')
insert into PXuat values(N'X02', '2019-3-5', N'NV03')
insert into PXuat values(N'X03', '2019-12-12', N'NV01')
insert into PXuat values(N'X04', '2019-6-2', N'NV02')
insert into PXuat values(N'X05', '2019-5-18', N'NV01')

--select * from PNhap

insert into Xuat values(N'X01', N'SP03', 5)
insert into Xuat values(N'X02', N'SP01', 3)
insert into Xuat values(N'X03', N'SP02', 1)
insert into Xuat values(N'X04', N'SP03', 2)
insert into Xuat values(N'X05', N'SP05', 1)

--select * from Xuat

--a. Hãy xây dựng hàm đưa ra thông tin các sản phẩm của hãng có tên nhập từ bàn phím.
create function CauA(@TenHang nvarchar(20))
returns @BangA table (
				MaSP nchar(10), 
				TenSP nvarchar(20),
				SoLuong int,
				MauSac nvarchar(20),
				GiaBan money,
				DonViTinh nvarchar(10),
				MoTa nvarchar(max))
as
	begin
		insert into @BangA 
		select MaSP, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa
		from SanPham inner join HangSX
		on SanPham.MaHangSX = HangSX.MaHangSX
		where TenHang = @TenHang
		
		return
	end

select * from CauA(N'Samsung')

--b. Hãy viết hàm Đưa ra danh sách các sản phẩm và hãng sản xuất tương ứng đã được nhập từ ngày x đến ngày y, với x,y nhập từ bàn phím.
create function CauB(@x date, @y date)
returns @BangB table(
					MaSP nchar(10),
					TenSP nvarchar(20),
					TenHang nvarchar(20),
					NgayNhap date,
					SoLuongN int,
					DonGiaN money
					)
as
	begin
		insert into @BangB
		select SanPham.MaSP, TenSP, TenHang, NgayNhap, SoLuongN, DonGiaN
		from Nhap inner join SanPham on Nhap.MaSP = SanPham.MaSP
				  inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
		          inner join PNhap on PNhap.SoHDN = Nhap.SoHDN
		where NgayNhap between @x and @y
		return
	end

select * from CauB('2019-2-5' ,'2020-6-14')

--c. Hãy xây dựng hàm Đưa ra danh sách các sản phẩm theo hãng sản xuất và 1 lựa chọn,
--nếu lựa chọn = 0 thì Đưa ra danh sách các sản phẩm có SoLuong = 0, ngược lại lựa chọn
--=1 thì Đưa ra danh sách các sản phẩm có SoLuong >0.
 
 create function Cauc (@hangsx nvarchar(20),@x int )
 returns @Bangc table(MaSP nchar(10),
    
	TenSP nvarchar(20),
	SoLuong int,
	MauSac nvarchar(20),
	GiaBan money,
	DonViTinh nchar(10),
	MoTa nvarchar(max))
as
begin
    if(@x = 1 )
	  begin
        insert into @Bangc
	    select Masp,TenSP,SoLuong,MauSac,GiaBan,DonViTinh,MoTa 
	    from SanPham inner join HangSX on sanpham.MaHangSX=Hangsx.MaHangSX
	    where TenHang=@hangsx and SoLuong = 0
	  end 
	else 
	   begin
        insert into @Bangc
	    select masp,TenSP,SoLuong,MauSac,GiaBan,DonViTinh,MoTa 
	    from SanPham inner join HangSX on sanpham.MaHangSX=Hangsx.MaHangSX
	    where TenHang=@hangsx and SoLuong > 0
	  end 
	  return 
end
select * from CauC(N'Samsung', 0)
select * from CauC(N'Samsung', 1)

--d. Hãy xây dựng hàm Đưa ra danh sách các nhân viên có tên phòng nhập từ bàn phím.

create function CauJ()
returns @BangJ table(
					 MaSP nchar(10),
					 MaHangSX nchar(10),
					 TenSP nvarchar(20),
					 SoLuong int,
					 MauSac nvarchar(20),
					 GiaBan money,
					 DonViTinh nchar(10),
					 MoTa nvarchar(max),
					 TenHang nvarchar(20)
					 )
as
	begin
		insert into @BangJ
		select MaSP, SanPham.MaHangSX, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa, TenHang
		from SanPham inner join HangSX
		on SanPham.MaHangSX = HangSX.MaHangSX
		return
	end

select * from CauJ()

--b. Tạo thủ tục nhập dữ liệu cho bảng sản phẩm với các tham biến truyền vào MaSP, 
--TenHangSX, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa. Hãy kiểm tra xem 
--nếu MaSP đã tồn tại thì cập nhật thông tin sản phẩm theo mã, ngược lại thêm mới sản phẩm 
--vào bảng SanPham.

create proc CauB2(@MaSP nchar(10),
					 @MaHangSX nchar(10),
					 @tenSP nvarchar(20),
					 @SoLuong int,
					 @MauSac nvarchar(20),
					 @GiaBan money,
					 @DonViTinh nchar(10),
					@MoTa nvarchar(max))
as
	begin
	  if(exists(select*from SanPham where SanPham.MaSP=@Masp))
	    begin
		  update SanPham
		  set  Sanpham.MaHangSX = @MaHangSX, TenSP = @TenSP, SoLuong = @SoLuong,
					MauSac = @MauSac, GiaBan = @GiaBan, DonViTinh = @DonViTinh, MoTa = @MoTa
		  where SanPham.MaSP=@Masp
		end
	  else 
	    begin
		  insert into SanPham values (@Masp, @MaHangSX, @tenSP,@Soluong,@Mausac,@Giaban,@donvitinh,@mota)
		end 
		
	end
	go 
	
select * from HangSX
select * from SanPham
	execute CauB2 N'SP05', N'H03', N'V3', 500, N'Đen', 10000000, N'Chiếc', N'Hàng cao cấp'
	execute CauB2 N'SP06', N'H03', N'V3', 500, N'Đen', 10000000, N'Chiếc', N'Hàng cao cấp'