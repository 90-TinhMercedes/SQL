create database QuanLyDaoTao_12052021

use QuanLyDaoTao_12052021

create table HOCVIEN(
	MaHV char(10) primary key,
	TenHV nvarchar(50),
	DiaChi nvarchar(50),
	NgaySinh date
)

create table MONHOC(
	MaMH char(10) primary key,
	TenMH nvarchar(50),
	MoTa nvarchar(50)
)

create table DIEM(
	MaHV char(10),
	MaMH char(10),
	DiemPra float,
	DiemQFX float,
	NgayThi date,
	constraint PK_DIEM primary key (MaHV, MaMH),
	constraint FK_DIEM_01 foreign key (MaHV) references HOCVIEN(MaHV) on update cascade on delete cascade,
	constraint FK_DIEM_02 foreign key (MaMH) references MONHOC(MaMH) on update cascade on delete cascade
)

-- cau 01
create trigger trg_Insert_HocVien
on HOCVIEN
for insert
as
	begin
		declare @namHienTai int
		declare @namSinh int
		set @namHienTai = YEAR(GETDATE())
		select @namSinh = YEAR(NgaySinh) from inserted
		if ((@namHienTai - @namSinh) < 18)
			begin
				raiserror (N'Không đủ 18 tuổi.', 16, 1)
				rollback transaction
			end
	end

select * from HOCVIEN
--insert into HOCVIEN values ('K005', 'Vu Linh Chi', 'Ha Dong', '12/07/1990') -- hop le
insert into HOCVIEN values ('K007', 'Nguyen Huu Nguyen', 'Phu Ly', '12/10/2009') -- khong hop le
select * from HOCVIEN

-- cau 02
create trigger trgDelete_MonHoc 
on MONHOC
for delete
as
	begin
		raiserror (N'Không được phép xoá môn học.', 16, 1)
		rollback transaction
	end

insert into MONHOC values('MH01', 'Mon hoc 01', 'Mo ta 01')
select * from MONHOC
delete from MONHOC where MaMH = 'MH01'
select * from MONHOC


-- cau 03
alter table DIEM
	add TongDiem float

create trigger 





















