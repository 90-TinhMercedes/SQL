--Câu 1: (2.5 điểm)
--Viết script tạo csdl QLbanhang gồm 3 bảng theo các yêu cầu sau:
--+ CongTy(MaCongTy, TenCongTy, DiaChi)
--+ SanPham(MaSanPham, TenSanPham, SoLuongCo, GiaBan)
--+ CungUng(MaCongTy, MaSanPham, SoluongCungung)
--+ Tạo lược đồ CSDL
--+ Nhập dữ liệu: 3 công ty, 3 sản phẩm và 5 cung ứng.
--+ Viết 3 câu lệnh select để xem dữ liệu của 3 bảng

create database FilePhuongShare_Lesson01

use FilePhuongShare_Lesson01

create table CONGTY (
	MaCongTy char(10) primary key,
	TenCongTy nvarchar(50),
	DiaChi nvarchar(50)
)

create table SANPHAM (
	MaSanPham char(10) primary key,
	TenSanPham nvarchar(50),
	SoLuongCo int,
	GiaBan money
)

create table CUNGUNG (
	MaCongTy char(10),
	MaSanPham char(10),
	SoLuongCungUng int,
	constraint PK_CUNGUNG primary key (MaCongTy, MaSanPham),
	constraint FK_CUNGUNG_01 foreign key (MaCongTy) references CONGTY(MaCongTy) on update cascade on delete cascade,
	constraint FK_CUNGUNG_02 foreign key (MaSanPham) references SANPHAM(MaSanPham) on update cascade on delete cascade
)

insert into CONGTY values ('CTY01', 'Cong ty 01', 'Dia chi 01')
insert into CONGTY values ('CTY02', 'Cong ty 02', 'Dia chi 02')
insert into CONGTY values ('CTY03', 'Cong ty 03', 'Dia chi 03')

insert into SANPHAM values ('SP01', 'San pham 01', 200, 10000)
insert into SANPHAM values ('SP02', 'San pham 02', 200, 15000)
insert into SANPHAM values ('SP03', 'San pham 03', 200, 20000)

insert into CUNGUNG values ('CTY01', 'SP02', 15)
insert into CUNGUNG values ('CTY02', 'SP01', 20)
insert into CUNGUNG values ('CTY01', 'SP01', 20)

select * from CONGTY
select * from SANPHAM
select * from CUNGUNG

--Câu 2: (2.5. điểm)
--Tạo view đưa ra mã sản phẩm, tên sản phẩm, số lượng có và số lượng đã cung ứng của các sản phẩm
alter view cau02
as
	select SANPHAM.MaSanPham, TenSanPham, SoLuongCo, sum(SoLuongCungUng) as SoLuongCungUng
	from CONGTY inner join CUNGUNG on CONGTY.MaCongTy = CUNGUNG.MaCongTy
	inner join SANPHAM on SANPHAM.MaSanPham = CUNGUNG.MaSanPham
	group by SANPHAM.MaSanPham, TenSanPham, SoLuongCo, SoLuongCungUng

select * from CONGTY
select * from SANPHAM
select * from CUNGUNG
select * from cau02


--Câu 3: (2.5. điểm)
--Viết thủ tục thêm mới 1 công ty với mã công ty, tên công ty, địa chỉ nhập từ bàn phím, 
--nếu tên công ty đó tồn tại trước đó hãy hiển thị thông báo và trả về 1, 
--ngược lại cho phép thêm mới và trả về 0.

create procedure cau03 (@maCongTy char(10), @tenCongTy nvarchar(50), @diaChi nvarchar(50), @result int output)
as
	begin
		if (exists (select * from CONGTY where MaCongTy = @maCongTy))
			begin
				print N'Công ty với mã ' + @maCongTy + N' đã tồn tại.'
				set @result = 1
			end
		else
			begin
				set @result = 0
				insert into CONGTY values (@maCongTy, @tenCongTy, @diaChi)
			end
		return @result
	end

select * from CONGTY
declare @notification int
--execute cau03 'CTY01', 'Cong ty 04', 'Dia chi 04', @notification output -- Mã công ty đã tồn tại. Không hợp lệ
execute cau03 'CTY04', 'Cong ty 04', 'Dia chi 04', @notification output -- Hợp lệ
select @notification as Result
select * from CONGTY


--Câu 4: (2.5. điểm)
--Tạo Trigger Update trên bảng CUNGUNG cập nhật lại số lượng cung ứng, 
--kiểm tra xem nếu số lượng cung ứng mới – số lượng cung ứng cũ <= số lượng có hay không?  
--nếu thỏa mãn hãy cập nhật lại số lượng có  trên bảng SANPHAM, ngược lại đưa ra thông báo.

create trigger cau04
on CUNGUNG
for update
as
	begin
		declare @soLuongTrongKho int, @soLuongCu int, @soLuongMoi int, @maSanPhamUpdate char(10)
		select @soLuongTrongKho = SoLuongCo from SANPHAM
		select @soLuongCu = SoLuongCungUng from deleted
		select @soLuongMoi = SoLuongCungUng, @maSanPhamUpdate = MaSanPham from inserted
		if (@soLuongTrongKho < (@soLuongMoi - @soLuongCu))
			begin
				print N'Hàng còn lại trong kho không đủ để cung ứng.'
				rollback transaction
			end
		else
			update SANPHAM set SoLuongCo = SoLuongCo - (@soLuongMoi - @soLuongCu) where MaSanPham = @maSanPhamUpdate
	end

select * from CONGTY
select * from SANPHAM
select * from CUNGUNG
--update CUNGUNG set SoLuongCungUng = SoLuongCungUng - 5 where MaCongTy = 'CTY01' and MaSanPham = 'SP01'
update CUNGUNG set SoLuongCungUng = SoLuongCungUng + 10 where MaCongTy = 'CTY01' and MaSanPham = 'SP02'
select * from CONGTY
select * from SANPHAM
select * from CUNGUNG



