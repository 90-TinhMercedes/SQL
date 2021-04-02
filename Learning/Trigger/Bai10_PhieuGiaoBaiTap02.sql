create database Bai10_PhieuGiaoBaiTap02

use Bai10_PhieuGiaoBaiTap02

create table MATHANG (
	MaHang char(10) primary key,
	TenHang nvarchar(50),
	SoLuong int
)

create table NHATKYBANHANG(
	STT int identity(1, 1) primary key,
	Ngay date,
	NguoiMua nvarchar(50),
	MaHang char(10),
	SoLuong int,
	GiaBan money,
	constraint FK_NHATKYBANHANG foreign key (MaHang) references MATHANG(MaHang) on update cascade on delete cascade
)

insert into MATHANG values ('H01', 'Hang 01', 100)
insert into MATHANG values ('H02', 'Hang 02', 200)
insert into MATHANG values ('H03', 'Hang 02', 150)

select * from MATHANG
select * from NHATKYBANHANG

update MATHANG set TenHang = 'Hang 03' where MaHang = 'H03'
update MATHANG set SoLuong = 200 where MaHang = 'H01'

--a. trg_nhatkybanhang_insert. Trigger này có chức năng tự động
--giảm số lượng hàng hiện có (Trong bảng MATHANG) khi một
--mặt hàng nào đó được bán (tức là khi câu lệnh INSERT được thực
--thi trên bảng NHATKYBANHANG)

create trigger userInsertNHATKYBANHANG
on NHATKYBANHANG
for insert
as
	begin
		update MATHANG set MATHANG.SoLuong = MATHANG.SoLuong - inserted.SoLuong
		from MATHANG inner join inserted on MATHANG.MaHang = inserted.MaHang
	end

drop trigger userInsertNHATKYBANHANG

select * from MATHANG
select * from NHATKYBANHANG
insert into NHATKYBANHANG values ('01/24/2021', 'TinhMercedes', 'H01', 10, 5000)
insert into NHATKYBANHANG values ('01/24/2021', 'TinhLoveVeigar', 'H02', 20, 5000)
insert into NHATKYBANHANG values ('01/24/2021', 'HIT TinhMercedes', 'H01', 15, 10000)
select * from MATHANG
select * from NHATKYBANHANG

--b. trg_nhatkybanhang_update_soluong được kích hoạt khi ta tiến
--hành cập nhật cột SOLUONG cho một bản ghi của bảng
--NHATKYBANHANG (lưu ý là chỉ cập nhật đúng một bản ghi)

alter trigger userUpdateNHATKYBANHANG_way01
on NHATKYBANHANg
for update
as
	begin
		if update(SoLuong)
			update MATHANG set SoLuong = MATHANG.SoLuong - (inserted.SoLuong - deleted.SoLuong)
			from deleted inner join inserted on deleted.STT = inserted.STT
			inner join MATHANG on deleted.MaHang = MATHANG.MaHang
	end

drop trigger userUpdateNHATKYBANHANG_way01

select * from MATHANG
select * from NHATKYBANHANG
update NHATKYBANHANG set SoLuong = SoLuong + 5 where STT = 2
update NHATKYBANHANG set SoLuong = SoLuong + 10 where STT = 3
select * from MATHANG
select * from NHATKYBANHANG

create trigger userUpdateNHATKYBANHANG_way02
on NHATKYBANHANG
for update
as
	begin
		declare @before int
		declare @after int
		select @before = SoLuong from deleted
		select @after = SoLuong from inserted
		update MATHANG set MATHANG.SoLuong = MATHANG.SoLuong - (@after - @before)
		from deleted inner join MATHANG on deleted.MaHang = MATHANG.MaHang
		inner join inserted on deleted.STT = inserted.STT
	end

drop trigger userUpdateNHATKYBANHANG_way02

select * from MATHANG
select * from NHATKYBANHANG
update NHATKYBANHANG set SoLuong = SoLuong + 5 where STT = 2
update NHATKYBANHANG set SoLuong = SoLuong + 10 where STT = 3
select * from MATHANG
select * from NHATKYBANHANG


--c. Trigger dưới đây được kích hoạt khi câu lệnh INSERT được sử dụng
--để bổ sung một bản ghi mới cho bảng NHATKYBANHANG. Trong
--trigger này kiểm tra điều kiện hợp lệ của dữ liệu là số lượng hàng bán
--ra phải nhỏ hơn hoặc bằng số lượng hàng hiện có. Nếu điều kiện này
--không thoả mãn thì huỷ bỏ thao tác bổ sung dữ liệu.

create trigger userInsertNHATKYBANHANG_withCondition
on NHATKYBANHANG
for insert
as
	begin
		declare @soLuongCo int
		declare @soLuongBan int
		declare @maHang char(10)
		select @maHang = inserted.MaHang, @soLuongBan = inserted.SoLuong from inserted
		select @soLuongCo = MATHANG.SoLuong from MATHANG where MaHang = @maHang
		if (@soLuongCo < @soLuongBan)
			begin
				raiserror('Error: Hang khong du de ban.', 16, 1)
				rollback transaction
			end
		else
			update MATHANG set SoLuong = MATHANG.SoLuong - @soLuongBan where MaHang = @maHang
	end

select * from MATHANG
select * from NHATKYBANHANG
delete from NHATKYBANHANG where STT = 6 -- trước đây STT 6 nhập lỗi :< hic
insert into NHATKYBANHANG values ('07/25/2020', 'Love Veigar', 'H03', 500, 12000) -- Hang khong du de cung cap
insert into NHATKYBANHANG values ('07/25/2020', 'Love Veigar', 'H03', 15, 12000)
select * from MATHANG
select * from NHATKYBANHANG

--d. Trigger dưới đây nhằm để kiểm soát lỗi update bảng
--nhatkybanhang, nếu update >1 bản ghi thì thông báo lỗi(Trigger4
--chỉ làm trên 1 bản ghi), quay trở về. Ngược lại thì update lại số
--lượng cho bảng mathang.

alter trigger cauD
on NHATKYBANHANG
for update
as
	begin
		declare @maHang char(10)
		declare @before int
		declare @after int
		if (select count(*) from inserted) > 1
			begin
				raiserror('Khong duoc sua nhieu hon 01 dong lenh.', 16, 1)
				rollback tran
				return
			end
		else
			if update(SoLuong)
				begin
					select @maHang = MaHang from inserted
					select @before = deleted.SoLuong from deleted
					select @after = inserted.SoLuong from inserted
					update MATHANG set MATHANG.SoLuong = MATHANG.SoLuong - (@after - @before)
					--from deleted inner join MATHANG on deleted.MaHang = MATHANG.MaHang
					--inner join inserted on deleted.STT = inserted.STT
					where MATHANG.MaHang = @maHang
				end
	end

drop trigger cauD

select * from MATHANG
select * from NHATKYBANHANG
update NHATKYBANHANG set SoLuong = SoLuong + 5 where STT = 4
update NHATKYBANHANG set SoLuong = SoLuong + 5 where STT = 5
select * from MATHANG
select * from NHATKYBANHANG


--e. Hay tao Trigger xoa 1 ban ghi bang nhatkybanhang, neu xoa nhieu hon
--1 record thi hay thong bao loi xoa ban ghi, nguoc lai hay update bang
--mathang voi cot so luong tang len voi ma hang da xoa o bang
--nhatkybanhang

create trigger cauE
on NHATKYBANHANG
for delete
as
	begin
		declare @maHang char(10)
		declare @soLuongHuy int
		select @maHang = MaHang from deleted;
		select @soLuongHuy = deleted.soLuong from deleted
		update MATHANG set SoLuong = SoLuong + @soLuongHuy where MaHang = @maHang
	end

select * from MATHANG
select * from NHATKYBANHANG
delete from NHATKYBANHANG where STT = 8
select * from MATHANG
select * from NHATKYBANHANG










