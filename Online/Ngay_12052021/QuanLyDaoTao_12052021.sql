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

insert into HOCVIEN values ('HV01', 'Hoc Vien 01', 'Dia chi 01', '12/25/2005') -- khong du 18 tuoi
insert into HOCVIEN values ('HV01', 'Hoc Vien 01', 'Dia chi 01', '12/25/2003')

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

alter trigger trgAfter_Diem on DIEM
for insert, update
as
	begin
		declare @diemPra float, @diemQFX float
		declare @tongDiem float
		declare @maHV char(10), @maMH char(10)
		select @diemPra = DiemPra, @diemQFX = DiemQFX, @maHV = MaHV, @maMH = MaMH from inserted
		set @tongDiem = @diemPra + @diemQFX
		update DIEM set TongDiem = @tongDiem where MaHV = @maHV and MaMH = @maMH
	end

select * from DIEM
--select * from MONHOC
--select * from HOCVIEN
--delete from DIEM where MaHV = 'K005' and MaMH = 'MH01'
insert into DIEM values ('K005', 'MH01', 7.5, 2.6, '12/18/2020', 0)
update DIEM set DiemPra = 8 where MaHV = 'K005' and MaMH = 'MH01' -- Update lại DiemPra
select * from DIEM


-- cau 04
--câu lệnh vô hiệu hoá khoá ngoài
--ALTER TABLE hangtonkho
--NOCHECK CONSTRAINT fk_htk_id_sanpham; 

alter trigger trgDelete_HocVien on HOCVIEN
for delete
as
	begin
		declare @maHV char(10)
		select @maHV = MaHV from deleted
		if (not exists (select * from HOCVIEN where MaHV = @maHV))
			begin
				raiserror (N'Không tồn tại học viên này.', 16, 1)
				rollback transaction
			end
		else
			delete from HOCVIEN
	end


--Thêm học viên để tiến hành test lại
insert into HOCVIEN values ('HV01', 'Hoc Vien 01', 'Dia chi 01', '12/25/2003')
insert into HOCVIEN values ('K005', 'Vu Linh Chi', 'Ha Dong', '12/07/1990')

select * from HOCVIEN
--delete from HOCVIEN where MaHV = 'HV02' -- Không tồn tại học viên có mà HV02
delete from HOCVIEN where MaHV = 'HV01' -- hợp lệ
select * from HOCVIEN



















