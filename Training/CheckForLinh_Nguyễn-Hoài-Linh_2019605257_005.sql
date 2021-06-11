create database QLTruongHoc
go
use QLTruongHoc
go

create table GiaoVien(
	MaGV char(10) primary key,
	TenGV nvarchar(50)
)
go
create table Lop(
	MaLop varchar(10) primary key,
	TenLop nvarchar(50),
	Phong char(10),
	SiSo int,
	MaGV char(10),
	constraint FK_Lop foreign key (MaGV) references GiaoVien(MaGV) on update cascade on delete cascade
)
go
create table SinhVien(
	MaSV varchar(10) primary key,
	TenSV nvarchar(50),
	GioiTinh nvarchar(50),
	QueQuan nvarchar(50),
	MaLop varchar(10),
	constraint FK_SinhVien foreign key (MaLop) references Lop(MaLop) on update cascade on delete cascade
)
go

insert into GiaoVien values ('GV01',N'Nguyễn Thị A')
insert into GiaoVien values ('GV02',N'Nguyễn Thị B')
insert into GiaoVien values ('GV03',N'Nguyễn Văn C')

insert into Lop values ('L01',N'Lớp 1','P01',30,'GV01')
insert into Lop values ('L02',N'Lớp 2','P02',40,'GV02')
insert into Lop values ('L03',N'Lớp 3','P03',50,'GV03')

insert into SinhVien values ('SV01', N'Nguyễn Ngọc A',N'nữ', N'Hà Tĩnh','L01')
insert into SinhVien values ('SV02', N'Nguyễn Ngọc B',N'nữ', N'Hà Nội','L02')
insert into SinhVien values ('SV03', N'Nguyễn Ngọc C',N'nam', N'Hà Nam','L03')
insert into SinhVien values ('SV04', N'Nguyễn Ngọc D',N'nữ', N'Hà Giang','L01')
insert into SinhVien values ('SV05', N'Nguyễn Ngọc E',N'nam', N'Hà Tĩnh','L02')

select *from GiaoVien
select *from Lop
select *from SinhVien
--câu 2
create function cau2 (@tenlop nvarchar(50), @tengv nvarchar(50))
returns @banga table (MaSV char(10),
						TenSV nvarchar(50),
						GioiTinh nvarchar(50),
						QueQuan nvarchar(50))
as
begin
	insert into @banga
	select MaSV, TenSV, GioiTinh, QueQuan
	from SinhVien inner join Lop on SinhVien.MaLop=Lop.MaLop
					inner join GiaoVien on GiaoVien.MaGV=Lop.MaGV
	where TenLop=@tenlop and TenGV=@tengv
	return
end

select *from GiaoVien
select *from Lop
select *from SinhVien
select *from cau2 (N'Lớp 1', N'Nguyễn Thị A')
select *from cau2 (N'Lớp 2', N'Nguyễn Thị B')

--câu 3
create procedure cau03(@maSV char(10), @tenSV nvarchar(50), @gioiTinh nvarchar(50), @queQuan nvarchar(50), @tenLop nvarchar(50))
as
	begin
		declare @maLopThemSinhVien char(10)
		if (not exists (select * from LOP where TenLop = @tenLop))
			begin
				print N'Tên lớp: ' + @tenLop + N' không tồn tại.'
			end
		else
			begin
				select @maLopThemSinhVien = MaLop from LOP where TenLop = @tenLop
				insert into SINHVIEN values (@maSV, @tenSV, @gioiTinh, @queQuan, @maLopThemSinhVien)
			end
	end


select * from Lop
select * from SinhVien
execute cau03 'SV06', N'Nguyễn Ngọc F', N'nữ', N'Hà Nội', N'Lớp 4' -- Tên lớp: Lớp 4 không tồn tại
execute cau03 'SV06', N'Nguyễn Ngọc F', N'nữ', N'Hà Nội', N'Lớp 3' -- Tên lớp: Lớp 3 tồn tại. Hợp lệ
select * from Lop
select * from SinhVien


--câu 4
create trigger cau04 on SinhVien
for update
as
	begin
		declare @maLopCu char(10), @maLopMoi char(10), @siSoLopCu int, @siSoLopMoi int
		select @maLopCu = MaLop from deleted
		select @maLopMoi = MaLop from inserted
		select @siSoLopCu = COUNT(MaSV) from SINHVIEN where MaLop = @maLopCu
		select @siSoLopMoi = COUNT(MaSV) from SINHVIEN where MaLop = @maLopMoi
		update LOP set SiSo = @siSoLopCu where MaLop = @maLopCu
		update LOP set SiSo = @siSoLopMoi where MaLop = @maLopMoi
	end

select * from Lop
select * from SinhVien
update SinhVien set MaLop = 'L01' where MaSV = 'SV02'
select * from Lop
select * from SinhVien
