create database Bai10_PhieuGiaoBaiTap01

use Bai10_PhieuGiaoBaiTap01

create table HANG(
	MaHang char(10) primary key,
	TenHang nvarchar(50), 
	SoLuong int,
	GiaBan money
)

create table HOADON(
	MaHD char(10) primary key,
	MaHang char(10),
	SoLuongBan int,
	NgayBan datetime
	constraint FK_HOADON foreign key (MaHang) references HANG(MaHang) on update cascade on delete cascade
)

insert into HANG values ('H01', 'Hang 01', 15, 5000)
insert into HANG values ('H02', 'Hang 02', 20, 10000)
insert into HANG values ('H03', 'Hang 03', 10, 7000)
insert into HANG values ('H04', 'Hang 04', 19, 12000)
insert into HANG values ('H05', 'Hang 05', 23, 6000)

insert into HOADON values ('HD01', 'H01', 12, '12/24/2020')
drop table HOADON


--Bài 1. Hãy tạo 1 trigger insert HoaDon, hãy kiểm tra xem mahang cần mua có tồn
--tại trong bảng HANG không, nếu không hãy đưa ra thông báo.
-- Nếu thỏa mãn hãy kiểm tra xem: soluongban <= soluong? Nếu không hãy
--đưa ra thông báo.
-- Ngược lại cập nhật lại bảng HANG với: soluong = soluong - soluongban

alter trigger userInsertHoaDon
on HOADON
for insert
as
	begin
		if(not exists (select * from HANG inner join inserted on HANG.MaHang = inserted.MaHang))
			begin
				raiserror('Error: Khong co mat hang nay.', 16, 1)
				rollback transaction
			end
		else
			begin
				declare @soLuong int
				declare @soLuongBan int
				select @soLuong = SoLuong from HANG inner join inserted on HANG.MaHang = inserted.MaHang;
				select @soLuongBan = inserted.SoLuongBan from inserted;
				if(@soLuong < @soLuongBan)
					begin
						raiserror('Error: Khong du hang de ban.', 16, 1)
						rollback transaction
					end
				else
					update HANG set SoLuong = SoLuong - SoLuongBan from HANG inner join inserted
					on HANG.MaHang = inserted.MaHang
			end
	end

drop trigger userInsertHoaDon
select * from HANG
select * from HOADON
insert into HOADON values ('HD01', 'H06', 50, '02/13/2021')  -- không tồn tại mặt hàng này
insert into HOADON values ('HD02', 'H05', 50, '02/13/2021')  -- không đủ số lượng để bán
insert into HOADON values ('HD03', 'H02', 10, '02/13/2021')  -- hợp lệ
select * from HANG
select * from HOADON

--Bài 2. Viết trigger kiểm soát việc Delete bảng HOADON, Hãy cập nhật lại soluong
--trong bảng HANG với: SOLUONG =SOLUONG + DELETED.SOLUONGBAN

create trigger userDeleteHoaDon
on HOADON
for delete
as
	begin
		update HANG set SoLuong = SoLuong + deleted.SoLuongBan
		from HANG inner join deleted on HANG.MaHang = deleted.MaHang
	end

select * from HANG
select * from HOADON
delete from HOADON where MaHD = 'HD03'
select * from HANG
select * from HOADON


--Bài 3. Hãy viết trigger kiểm soát việc Update bảng HOADON. Khi đó hãy update
--lại soluong trong bảng HANG

create trigger userUpdateHoaDon
on HOADON
for update
as
	begin
		declare @before int
		declare @after int
		select @before = deleted.SoLuongBan from deleted
		select @after = inserted.SoLuongBan from inserted
		update HANG set SoLuong = SoLuong - (@after - @before) 
		from HANG inner join inserted on HANG.MaHang = inserted.MaHang
	end


select * from HANG
select * from HOADON
update HOADON set SoLuongBan = SoLuongBan + 5 where MaHD = 'HD03'
update HOADON set SoLuongBan = SoLuongBan - 5 where MaHD = 'HD03'
select * from HANG
select * from HOADON




		





