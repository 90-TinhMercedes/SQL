use Sinhvien08

select * from DANG_KY
select * from DIEM
select * from DIEM_CHUYEN_DOI
select * from GIAO_VIEN
select * from KIEU_DIEM
select * from LOP
select * from MON_HOC
select * from SINH_VIEN
select * from TRONG_SO_KIEU_DIEM
select * from VUNG

-- Câu 05:
alter procedure prcChiTietSV (@maso varchar(5))
as
	begin
		declare @hoTen nvarchar(50)
		select @hoTen = HO + TEN from SINH_VIEN
		if (not exists (select * from VUNG where MA_SO = @maso))
			begin
				print N'Không tồn tại mã vùng ' + @maso + N' này.'
			end
		else
			select @hoTen as HoVaTen, DIEN_THOAI
			from SINH_VIEN inner join VUNG on SINH_VIEN.MA_SO = VUNG.MA_SO
			where SINH_VIEN.MA_SO = @maso
	end

-- test
select * from VUNG
execute prcChiTietSV '01234' -- không tồn tại mã vùng này.
execute prcChiTietSV '02124'
execute prcChiTietSV '11373'
drop procedure prcChiTietSV

-- Câu 06:
alter procedure prcDanhSachSV (@maso varchar(5))
as
	begin
		declare @hoTen nvarchar(50)
		select @hoTen = HO + TEN from SINH_VIEN
		if (not exists (select * from VUNG where MA_SO = @maso))
			begin
				print N'Không tồn tại mã vùng ' + @maso + N' này.'
			end
		else
			select @hoTen as HoVaTen, DIA_CHI, DIEN_THOAI, CO_QUAN, SINH_VIEN.MA_SO
			from SINH_VIEN inner join VUNG on SINH_VIEN.MA_SO = VUNG.MA_SO
			where SINH_VIEN.MA_SO = @maso
	end
-- test
execute prcDanhSachSV '01234' -- không tồn tại mã vùng này
execute prcDanhSachSV '07042' -- done








