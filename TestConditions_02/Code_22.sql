create database condition_02_code_22

use condition_02_code_22

create table CONGTY(
	MaCT char(10) primary key,
	TenCT nvarchar(50),
	TrangThai nvarchar(50),
	ThanhPho nvarchar(50)
)

create table SANPHAM(
	MaSP char(10) primary key,
	TenSP nvarchar(50),
	MauSac nvarchar(50),
	SoLuong int,
	GiaBan money
)

create table CUNGUNG(
	MaCT char(10),
	MaSP char(10),
	SoLuongCungUng int,
	constraint PK_CUNGUNG primary key (MaCT, MaSP),
	constraint FK_CUNGUNG_01 foreign key (MaCT) references CONGTY(MaCT) on update cascade on delete cascade,
	constraint FK_CUNGUNG_02 foreign key (MaSP) references SANPHAM(MaSP) on update cascade on delete cascade,
)

insert into CONGTY values ('CTY01', 'Cong Ty 01', 'Done', 'Thanh pho 01')
insert into CONGTY values ('CTY02', 'Cong Ty 02', 'Done', 'Thanh pho 02')
insert into CONGTY values ('CTY03', 'Cong Ty 03', 'Done', 'Thanh pho 03')

insert into SANPHAM values ('SP01', 'San Pham 01', 'Lam', 100, 10000)
insert into SANPHAM values ('SP02', 'San Pham 02', 'Lam', 5, 15000)
insert into SANPHAM values ('SP03', 'San Pham 03', 'Lam', 20, 20000)

insert into CUNGUNG values ('CTY01', 'SP01', 15)
insert into CUNGUNG values ('CTY01', 'SP02', 20)
insert into CUNGUNG values ('CTY01', 'SP03', 20)
insert into CUNGUNG values ('CTY02', 'SP02', 10)
insert into CUNGUNG values ('CTY02', 'SP03', 5)

select * from CONGTY
select * from SANPHAM
select * from CUNGUNG

-- cau 02:
alter procedure cau02(@maSanPham char(10))
as
	begin
		if(not exists (select * from SANPHAM where MaSP = @maSanPham))
			begin
				print N'Không tồn tại mã sản phẩm: ' + @maSanPham
			end
		else
			begin
				declare @soLuongSanPham int
				select @soLuongSanPham = SoLuong from SANPHAM where MaSP = @maSanPham
				if (@soLuongSanPham > 10)
					begin
						print N'Không được xoá sản phẩm này do số lượng > 10.'
					end
				else
					delete from SANPHAM where MaSP = @maSanPham	
			end
	end

select * from SANPHAM
execute cau02 'SP05' -- Không hợp lệ. Mã sản phẩm không tồn tại
execute cau02 'SP01' -- Mã tồn tại nhưng số lượng > 10
execute cau02 'SP02' -- Xoá thành công
select * from SANPHAM


-- cau 03:
create trigger cau03 on CUNGUNG
for insert
as
	begin
		declare @soLuongCungUngInsert int, @maSanPhamInsert char(10)
		declare @SoLuongTon int
		select @maSanPhamInsert = MaSP, @soLuongCungUngInsert = SoLuongCungUng from inserted
		select @SoLuongTon = SoLuong from SANPHAM where MaSP = @maSanPhamInsert
		if (@soLuongCungUngInsert > @SoLuongTon)
			begin
				raiserror(N'Số lượng sản phầm trong kho không đủ để cung ứng.', 16, 1)
				rollback transaction
			end
		else
			update SANPHAM set SoLuong = SoLuong - @soLuongCungUngInsert where MaSP = @maSanPhamInsert
	end

select * from SANPHAM
select * from CUNGUNG
--insert into CUNGUNG values ('CTY03', 'SP01', 500) -- Số lượng cung ứng > số lượng tồn. Không hợp lệ
insert into CUNGUNG values ('CTY03', 'SP01', 20) -- Hợp lệ
select * from SANPHAM
select * from CUNGUNG