create database DeHoangGui

use DeHoangGui

create table Sach (
	MaSach char(10) primary key,
	TenSach nvarchar(50),
	SoTrang int,
	SLTon int
)

create table PHIEUMUON (
	MaPM char(10) primary key,
	NgayM date,
	HoTenDG nvarchar(50)
)

create table SACHMUON (
	MaPM char(10),
	MaSach char(10),
	SoNgayMuon int,
	constraint PK_SACHMUON primary key (MaPM, MaSach),
	constraint FK_SACHMUON_01 foreign key (MaPM) references PHIEUMUON(MaPM) on update cascade on delete cascade,
	constraint FK_SACHMUON_02 foreign key (MaSach) references SACH(MaSach) on update cascade on delete cascade
)

insert into Sach values ('SA01', 'Sach 01', 15, 200)
insert into Sach values ('SA02', 'Sach 02', 20, 100)

insert into PHIEUMUON values ('PM01', '04/25/2021', 'Doc gia 01')
insert into PHIEUMUON values ('PM02', '04/20/2021', 'Doc gia 02')

insert into SACHMUON values ('PM01', 'SA01', 3)
insert into SACHMUON values ('PM01', 'SA02', 10)
insert into SACHMUON values ('PM02', 'SA01', 5)
insert into SACHMUON values ('PM02', 'SA02', 8)

select * from SACH
select * from PHIEUMUON
select * from SACHMUON

-- Cau 02:
create procedure cau02 (@maPM char(10), @ngayMuon date, @hoTenDocGia nvarchar(50), @result int output)
as
	begin
		declare @ngayHomNay date
		set @ngayHomNay = GETDATE()
		if (@ngayMuon > @ngayHomNay)
			begin
				print N'Ngày mượn không hợp lệ.'
				set @result = 1
			end
		else
			begin
				insert into PHIEUMUON values (@maPM, @ngayMuon, @hoTenDocGia)
				set @result = 0
			end
	end

select * from PHIEUMUON
declare @final int 
--execute cau02 'PM03', '04/29/2021', 'Doc gia 03', @final output -- ngày mượn không hợp lệ
execute cau02 'PM03', '04/25/2021', 'Doc gia 03', @final output -- ngày mượn hợp lệ
select @final as Result
select * from PHIEUMUON


-- Cau 03:
create trigger cau03
on SACHMUON
for delete
as
	begin
		declare @soNgayMuon int, @maSach char(10)
		select @soNgayMuon = SoNgayMuon, @maSach = MaSach from deleted
		if (@soNgayMuon < 5)
			begin
				raiserror (N'Số ngày mượn của phiếu này < 5, không hợp lệ', 16, 1)
				rollback transaction
			end
		else
			update SACH set SLTon = SLTon + 1 where MaSach = @maSach
	end

select * from SACH
select * from PHIEUMUON
select * from SACHMUON
--delete from SACHMUON where MaPM = 'PM01' and MaSach = 'SA01' -- số ngày < 5 hợp lệ
delete from SACHMUON where MaPM = 'PM01' and MaSach = 'SA02' -- số ngày > 5 hợp lệ
select * from SACH
select * from PHIEUMUON
select * from SACHMUON









