create database review_slide08

use review_slide08

create table HANG (
	MaHang char(10) primary key,
	TenHang nvarchar(50),
	DVTinh nvarchar(50),
	SLTon int
)

create table HDBAN (
	MaHD char(10) primary key,
	NgayBan datetime,
	HoTenKhach nvarchar(50)
)

create table HANGBAN (
	MaHD char(10),
	MaHang char(10),
	DonGia money,
	SoLuong int,
	constraint pk_HANGBAN primary key (MaHD, MaHang),
	constraint first_fk_HangBan foreign key (MaHD) references HDBAN(MaHD) on update cascade on delete cascade,
	constraint second_fk_HangBan foreign key (MaHang) references HANG(MaHang) on update cascade on delete cascade 
)

insert into HANG values ('H01', 'Hang 01', 'cai', 200)
insert into HANG values ('H02', 'Hang 02', 'chiec', 200)

insert into HDBAN values ('HD01', '12/25/2020', 'Tinh Mercedes')
insert into HDBAN values ('HD02', '08/20/2019', 'Tinh Main Veigar')
insert into HDBAN values ('HD03', '12/25/2020', 'Tinh Mercedes')

insert into HANGBAN values ('HD01', 'H01', 15000, 20)
insert into HANGBAN values ('HD02', 'H02', 20000, 20)
insert into HANGBAN values ('HD02', 'H01', 17000, 15)
insert into HANGBAN values ('HD01', 'H02', 9000, 7)

select * from HANG
select * from HDBAN
select * from HANGBAN


--Câu 4 (3đ): Hãy tạo Trigger để tự động giảm số lượng tồn (SLTon) trong bảng Hang, 
--mỗi khi thêm mới dữ liệu cho bảng HangBan. (Đưa ra thông báo lỗi nếu SoLuong>SLTon) 
create trigger cau04
on HANGBAN
for insert
as
	begin
		declare @SoLuongBan int
		declare @SoLuongTrongKho int
		declare @maSanPham char(10)
		select @SoLuongBan = SoLuong, @maSanPham = MaHang from inserted
		select @SoLuongTrongKho = SLTon from HANG
		if (@SoLuongBan > @SoLuongTrongKho)
			begin
				raiserror (N'Hàng trong kho không đủ để bán',16, 1)
				rollback transaction
			end
		else
			update HANG set SLTon = SLTon - @SoLuongBan where MaHang = @maSanPham
	end

select * from HANG
select * from HDBAN
select * from HANGBAN

--insert into HANGBAN values ('HD01', 'H01', 15000, 300) -- vượt quá số hàng tồn
insert into HANGBAN values ('HD01', 'H01', 15000, 10) -- hợp lệ
select * from HANG
select * from HDBAN
select * from HANGBAN

--Câu 05: Tạo trigger xoá một dòng trong bảng HANGBAN, update lại số lượng trong bản HANG
create trigger cau05
on HANGBAN
for delete
as
	begin
		declare @soLuongXoa int
		declare @maSanPham char(10)
		select @soLuongXoa = SoLuong, @maSanPham = MaHang from deleted
		update HANG set SLTon = SLTon + @soLuongXoa where MaHang = @maSanPham
	end

insert into HANGBAN values ('HD01', 'H02', 9000, 20)

select * from HANG
select * from HDBAN
select * from HANGBAN
delete from HANGBAN where MaHD = 'HD01' and MaHang = 'H02'
select * from HANG
select * from HDBAN
select * from HANGBAN

-- cau06 UPdate
create trigger cau06
on HANGBAN
for update
as
	begin
		declare @soLuongCu int, @soLuongMoi int
		declare @soLuongTrongKho int
		declare @maSanPham char(10)		
		select @soLuongCu = SoLuong from deleted
		select @soLuongMoi = SoLuong, @maSanPham = MaHang from inserted
		select @soLuongTrongKho = SLTon from HANG
		if (@soLuongTrongKho < (@soLuongMoi - @soLuongCu))
			begin
				print N'Số lượng trong kho không đủ để bán'
				rollback transaction
			end
		else
			update HANG set SLTon = SLTon - (@soLuongMoi - @soLuongCu) where MaHang = @maSanPham
	end

drop trigger cau06


--HANG 190 -> 195
--HANGBAN 10 -> 5
select * from HANG
select * from HDBAN
select * from HANGBAN
--update HANGBAN set SoLuong = SoLuong + 300 where MaHD = 'HD01' and MaHang = 'H01' -- không hợp lệ
--update HANGBAN set SoLuong = SoLuong + 10 where MaHD = 'HD01' and MaHang = 'H01' -- hợp lệ
update HANGBAN set SoLuong = SoLuong - 10 where MaHD = 'HD02' and MaHang = 'H02'
select * from HANG
select * from HDBAN
select * from HANGBAN



-- cau 07:
create trigger cau07
on HANGBAN
for update
as
	begin
		declare @soLuongCu int, @soLuongMoi int
		declare @soLuongTrongKho int
		declare @maSanPham char(10)		
		select @soLuongCu = SoLuong from deleted
		select @soLuongMoi = SoLuong, @maSanPham = MaHang from inserted
		select @soLuongTrongKho = SLTon from HANG

		if (@@ROWCOUNT > 1)
			begin
				print N'Không được cập nhật nhiều hơn 1 dòng'
				rollback transaction
			end

		else if (@soLuongTrongKho < (@soLuongMoi - @soLuongCu))
			begin
				print N'Số lượng trong kho không đủ để bán'
				rollback transaction
			end
		else
			update HANG set SLTon = SLTon - (@soLuongMoi - @soLuongCu) where MaHang = @maSanPham
	end

select * from HANG
select * from HDBAN
select * from HANGBAN
update HANGBAN set SoLuong = SoLuong + 5 where (MaHD = 'HD02' and MaHang = 'H01')
select * from HANG
select * from HDBAN
select * from HANGBAN


--cau 08
create trigger cau08
on HDBAN
for update
as
	begin
		if(@@ROWCOUNT > 1)
			begin
				print N'Không được cập nhật nhiều hơn 1 dòng'
				rollback transaction
			end			
	end

select * from HANG
select * from HDBAN
select * from HANGBAN
update HDBAN set NgayBan = '04/15/2021' where HoTenKhach = 'Tinh Main Veigar'
select * from HANG
select * from HDBAN
select * from HANGBAN

-- fix cho Nguyên
create trigger cau04
on HDBAN
for insert
as
	begin
		declare @ngayHomNay date
		declare @ngayBan date
		set @ngayHomNay = GETDATE()
		select @ngayBan = NgayBan from inserted
		if (@ngayBan != @ngayHomNay)
			begin
				raiserror (N'Ngày bán không trùng với ngày hôm nay.', 16, 1)
				rollback transaction
			end	
	end