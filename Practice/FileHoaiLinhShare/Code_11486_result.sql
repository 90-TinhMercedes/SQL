create database FileHoaiLinhShare_Code11486

use FileHoaiLinhShare_Code11486


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

-- cau 02:
create function cau02(@tenCongTy nvarchar(50), @ngayCungUng date)
returns table
as
	return	
		select TenSanPham, SoLuongCo, GiaBan
		from CUNGUNG inner join SANPHAM on CUNGUNG.MaSanPham = SANPHAM.MaSanPham
		inner join CONGTY on CUNGUNG.MaCongTy = CONGTY.MaCongTy
		where TenCongTy = @tenCongTy and NgayCungUng = @ngayCungUng

select * from CONGTY
select * from SANPHAM
select * from CUNGUNG
--select * from cau02('Cong Ty 01', '10/25/2020') 
select * from cau02('Cong Ty 02', '03/17/2021') 

-- cau 03:
create procedure cau03(@maCongTy char(10), @tenCongTy nvarchar(50), @diaChi nvarchar(50), @result int output)
as
	begin
		if(exists (select * from CONGTY where TenCongTy = @tenCongTy))
			begin
				print N'Tên công ty đã tồn tại.'
				set @result = 1 -- gán
			end
		else
			begin
				insert into CONGTY values (@maCongTy, @tenCongTy, @diaChi)
				set @result = 0
			end
	end

select * from CONGTY
declare @ketQua int
--execute cau03 'CTY05', 'Cong Ty 05', 'Dia chi 05', @ketQua output -- Tên công ty đã tồn tại. Không hợp lệ.
execute cau03 'CTY04', 'Cong Ty 04', 'Dia chi 04', @ketQua output -- Tên công ty hợp lệ.
select @ketQua as KetQua -- hiển thị 0 hoặc 1
select * from CONGTY


-- cau 04:
create trigger cau04 on CUNGUNG
for update
as
	begin
		declare @soLuongCungUngNew int, @soLuongCungUngOld int, @maSanPhamCungUngUpdate char(10)
		declare @soLuongCo int
		select @soLuongCungUngNew = SoLuongCungUng, @maSanPhamCungUngUpdate = MaSanPham from inserted
		select @soLuongCungUngOld = SoLuongCungUng from deleted
		select @soLuongCo = SoLuongCo from SANPHAM where MaSanPham = @maSanPhamCungUngUpdate
		if ((40 - 30) > 85)
			begin
				raiserror(N'Số lượng trong kho không đủ để cung ứng.', 16, 1)
				rollback transaction
			end
		else
			update SANPHAM set SoLuongCo = SoLuongCo - (@soLuongCungUngNew - @soLuongCungUngOld)
			where MaSanPham = @maSanPhamCungUngUpdate

	end

select * from SANPHAM
select * from CUNGUNG
--update CUNGUNG set SoLuongCungUng = 500 where MaCongTy = 'CTY01' and MaSanPham = 'SP01' --Số lượng cung ứng quá lớn, trong kho không đủ.
update CUNGUNG set SoLuongCungUng = 50 where MaCongTy = 'CTY01' and MaSanPham = 'SP01' --Số lượng cung ứng hợp lệ
select * from SANPHAM
select * from CUNGUNG
