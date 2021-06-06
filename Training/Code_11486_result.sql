create database Training_FileHoaiLinhShare_Code11486

use Training_FileHoaiLinhShare_Code11486

create table CONGTY(
	MaCongTy char(10) primary key,
	TenCongTy nvarchar(50),
	DiaChi nvarchar(50),
)

create table SANPHAM(
	MaSanPham char(10) primary key,
	TenSanPham nvarchar(50),
	SoLuongCo int,
	GiaBan money
)

create table CUNGUNG(
	MaCongTy char(10),
	MaSanPham char(10),
	SoLuongCungUng int,
	NgayCungUng date,
	constraint PK_CUNGUNG primary key (MaCongTy, MaSanPham),
	constraint FK_CUNGUNG_01 foreign key (MaCongTy) references CONGTY(MaCongTy) on update cascade on delete cascade,
	constraint FK_CUNGUNG_02 foreign key (MaSanPham) references SANPHAM(MaSanPham) on update cascade on delete cascade,
)

insert into CONGTY values ('CTY01', 'Cong Ty 01', 'Dia chi 01')
insert into CONGTY values ('CTY02', 'Cong Ty 02', 'Dia chi 02')
insert into CONGTY values ('CTY03', 'Cong Ty 03', 'Dia chi 03')

insert into SANPHAM values ('SP01', 'San Pham 01', 100, 10000)
insert into SANPHAM values ('SP02', 'San Pham 02', 5, 15000)
insert into SANPHAM values ('SP03', 'San Pham 03', 20, 20000)

insert into CUNGUNG values ('CTY01', 'SP01', 15, '10/25/2020')
insert into CUNGUNG values ('CTY01', 'SP02', 20, '03/17/2021')
insert into CUNGUNG values ('CTY01', 'SP03', 20, '03/17/2021')
insert into CUNGUNG values ('CTY02', 'SP02', 10, '03/17/2021')
insert into CUNGUNG values ('CTY02', 'SP03', 5, '03/17/2021')

select * from CONGTY
select * from SANPHAM
select * from CUNGUNG

-- câu 02:
create function cau02(@tenCongTy nvarchar(50), @ngayCungUng date)
returns table
as
	return select TenSanPham, SoLuongCo, GiaBan
	from CONGTY inner join CUNGUNG on CONGTY.MaCongTy = CUNGUNG.MaCongTy
	inner join SANPHAM on SANPHAM.MaSanPham = CUNGUNG.MaSanPham
	where TenCongTy = @tenCongTy and NgayCungUng = @ngayCungUng

select * from CONGTY
select * from SANPHAM
select * from CUNGUNG
select * from cau02('Cong Ty 01', '03/17/2021')
select * from cau02('Cong Ty 02', '03/17/2021')
select * from cau02('Cong Ty 02', '10/25/2020') -- không có

-- câu 03:
create procedure cau03(@maCongTy char(10), @tenCongTy nvarchar(50), @diaChi nvarchar(50), @ketQua int output)
as
	begin
		if (exists (select * from CONGTY where TenCongTy = @tenCongTy))
			begin
				print N'Tên công ty: ' + @tenCongTy + N' đã tồn tại.'
				set @ketQua = 1
			end
		else
			begin
				insert into CONGTY values (@maCongTy, @tenCongTy, @diaChi)
				set @ketQua = 0
			end		
	end

declare @thongBaoKetQuaTraVe int
select * from CONGTY
--execute cau03 'CTY05', 'Cong Ty 01', 'Dia chi 05', @thongBaoKetQuaTraVe output -- tên công ty đã tồn tại. Trả về 1
execute cau03 'CTY05', 'Cong Ty 05', 'Dia chi 05', @thongBaoKetQuaTraVe output -- tên công ty hợp lệ. Trả về 0
select @thongBaoKetQuaTraVe as ThongBao
select * from CONGTY

-- câu 04:
create trigger cau04 on CUNGUNG
for update
as
	begin
		declare @soLuongCungUngCu int, @soLuongCungUngMoi int, @soLuongCo int, @maSanPhamCungUngMoi char(10)
		select @soLuongCungUngCu = SoLuongCungUng from deleted
		select @soLuongCungUngMoi = SoLuongCungUng, @maSanPhamCungUngMoi = MaSanPham from inserted
		select @soLuongCo = SoLuongCo from SANPHAM where MaSanPham = @maSanPhamCungUngMoi
		if ((@soLuongCungUngMoi - @soLuongCungUngCu) > @soLuongCo)
			begin
				raiserror(N'Số lượng trong kho không đủ để cung ứng.', 16, 1)
				rollback transaction
			end
		else 
			begin
				update SANPHAM set SoLuongCo = SoLuongCo - (@soLuongCungUngMoi - @soLuongCungUngCu) where MaSanPham = @maSanPhamCungUngMoi
			end
	end

select * from SANPHAM
select * from CUNGUNG
--update CUNGUNG set SoLuongCungUng = 500 where MaCongTy = 'CTY01' and MaSanPham = 'SP03' -- số lượng trong kho không đủ để cung ứng
update CUNGUNG set SoLuongCungUng = 25 where MaCongTy = 'CTY01' and MaSanPham = 'SP03' -- hợp lệ
update CUNGUNG set SoLuongCungUng = 20 where MaCongTy = 'CTY01' and MaSanPham = 'SP03' -- hợp lệ
select * from SANPHAM
select * from CUNGUNG