CREATE DATABASE QLSV_NGAY_24022021

use QLSV_Ngay_24022021

create table LOP(
	MaLop char(10) primary key,
	TenLop nvarchar(50),
	Phong nvarchar(50)
)

create table SV(
	MaSV char(10) primary key,
	TenSV nvarchar(50),
	MaLop char(10),
	constraint fk_SV foreign key (MaLop) references LOP(MaLop) on update cascade on delete cascade
)

insert into LOP values ('1', 'CD', '1')
insert into LOP values ('2', 'DH', '2')
insert into LOP values ('3', 'LT', '3')
insert into LOP values ('4', 'CH', '4')

insert into SV values ('SV01', 'AAA', '1')
insert into SV values ('SV02', 'BBB', '2')
insert into SV values ('SV03', 'CCC', '1')
insert into SV values ('SV04', 'DDD', '3')

create function thongKeSoLuongSinhVienLop(@MaLop char(10))
returns int
as
	begin
		declare @SoLuong int 
		select @SoLuong = count (SV.MaLop)
		from SV, LOP
		where SV.MaLop= LOP.MaLop
		and LOP.MaLop = @MaLop
		group by LOP.TenLop
		return @SoLuong
	end

drop function thongKeSoLuongSinhVienLop

select  dbo.thongKeSoLuongSinhVienLop('1')
		
