create database condition_02_code_21

use condition_02_code_21

create table SACH(
	MaSach char(10) primary key,
	TenSach nvarchar(50),
	SLCo int,
	MaTG char(10),
	NgayXB date
)

create table NXB(
	MaNXB char(10) primary key,
	TenNXB nvarchar(50)
)

create table XUATSACH(
	MaNXB char(10), 
	MaSach char(10),
	SoLuong int,
	Gia money,
	constraint PK_XUATSACH primary key (MaNXB, MaSach),
	constraint FK_XUATSACH_01 foreign key (MaNXB) references NXB(MaNXB) on update cascade on delete cascade,
	constraint FK_XUATSACH_02 foreign key (MaSach) references SACH(MaSach) on update cascade on delete cascade
)


insert into SACH values ('S01', 'Sach 01', 100, 'TG01', '10/25/2020')
insert into SACH values ('S02', 'Sach 02', 150, 'TG03', '08/17/2020')
insert into SACH values ('S03', 'Sach 03', 200, 'TG05', '04/26/2021')

insert into NXB values ('NXB01', 'Nha Xuat Ban 01')
insert into NXB values ('NXB02', 'Nha Xuat Ban 02')

insert into XUATSACH values ('NXB01', 'S01', 10, 15000)
insert into XUATSACH values ('NXB01', 'S02', 15, 20000)
insert into XUATSACH values ('NXB01', 'S03', 20, 10000)
insert into XUATSACH values ('NXB02', 'S01', 5, 15000)
insert into XUATSACH values ('NXB02', 'S02', 15, 20000)

select * from SACH
select * from NXB
select * from XUATSACH


-- cau 02:
create procedure cau02(@maSach char(10), @ngayXB date)
as
	begin
		if(not exists (select * from SACH where MaSach = @maSach))
			begin
				print N'Không tồn tại sách có mã: ' + @maSach
			end
		else
			begin
				declare @toDay date
				set @toDay = GETDATE()
				if(@ngayXB >= @toDay)
					begin
						print N'Không thể sửa do ngày xuất bản >= ngày hôm nay.'
					end
				else
					begin
						update SACH set NgayXB = @ngayXB where MaSach = @maSach
					end
			end
	end

-- Hiện tại đang test tại ngày 20/05/2021

select * from SACH
execute cau02 'S05', '05/20/2021' -- không tồn tại mẫ sách S01. Không hợp lệ
execute cau02 'S01', '05/20/2021' -- ngày xuất bản không hợp lệ
execute cau02 'S01', '05/25/2021' -- ngày xuất bản không hợp lệ
execute cau02 'S01', '05/19/2021' -- hợp lệ
select * from SACH

-- cau 03:
create trigger cau03 on SACH
for insert 
as
	begin
		declare @namXuatBanInsert int
		declare @namHienTai int
		set @namHienTai = YEAR(GETDATE())
		select @namXuatBanInsert = YEAR(NgayXB) from inserted
		if(@namXuatBanInsert > @namHienTai)
			begin
				raiserror(N'Năm xuất bản > 2021. Không hợp lệ.', 16, 1)
				rollback transaction
			end
	end

select * from SACH
--insert into SACH values ('S04', 'Sach 04', 100, 'TG01', '10/25/2022') -- Năm 2022 không hợp lệ
insert into SACH values ('S04', 'Sach 04', 100, 'TG01', '04/15/2021') -- Năm 2022 không hợp lệ
select * from SACH