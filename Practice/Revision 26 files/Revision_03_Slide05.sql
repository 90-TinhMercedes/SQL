create database QLSach_Slide5

use QLSach_Slide5

create table TACGIA (
	MaTG char(10) primary key,
	TenTG nvarchar(50),
	SoLuongCo int
)

create table NHAXB (
	MaNXB char(10) primary key,
	TenNXB nvarchar(50),
	SoLuongCo int
)

create table SACH (
	MaSach char(10) primary key,
	TenSach nvarchar(50),
	MaNXB char(10),
	MaTG char(10),
	NamXB int,
	SoLuong int,
	DonGia money
	constraint fk_SACH_01 foreign key (MaNXB) references NHAXB(MaNXB) on update cascade on delete cascade,
	constraint fk_SACH_02 foreign key (MaTG) references TACGIA(MaTG) on update cascade on delete cascade
)

insert into TACGIA values('TG01', 'Tac gia 01', 3)
insert into TACGIA values('TG02', 'Tac gia 02', 5)
insert into TACGIA values('TG03', 'Tac gia 03', 2)

insert into NHAXB values('NXB01', 'Nha xuat ban 01', 4)
insert into NHAXB values('NXB02', 'Nha xuat ban 02', 2)
insert into NHAXB values('NXB03', 'Nha xuat ban 03', 5)

insert into SACH values('SA01', 'Sach 01', 'NXB02', 'TG01', 2019, 20, 15000)
insert into SACH values('SA02', 'Sach 02', 'NXB03', 'TG02', 2015, 15, 21000)
insert into SACH values('SA03', 'Sach 03', 'NXB01', 'TG02', 2017, 17, 17000)
insert into SACH values('SA04', 'Sach 04', 'NXB01', 'TG03', 2020, 9, 9000)
insert into SACH values('SA05', 'Sach 05', 'NXB01', 'TG01', 2019, 14, 16000)
insert into SACH values('SA06', 'Sach 06', 'NXB02', 'TG02', 2020, 22, 15500)

select * from TACGIA
select * from NHAXB
select * from SACH

--Câu 2 (3 đ): Hãy tạo hàm đưa ra thống kê tiền bán theo tên TG, gồm Masach, tensach, TenTG,TienBan (TienBan=SoLuong*DonGia) 
--với tham số truyền là TenTG(lưu ý: một tác giả có thể xuất bản nhiều sách -  gom nhóm lại kết quả).

create function cau02 (@TenTG nvarchar(50))
returns @ThongKe table (MaSach char(10), TenSach nvarchar(50), TenTG nvarchar(50), TienBan int)
as
	begin
		insert into @ThongKe
		select MaSach, TenSach, TACGIA.TenTG, sum(SoLuong * DonGia) as 'TienBan'
		from TACGIA inner join SACH on TACGIA.MaTG = SACH.MaTG
		where TenTG = @TenTG
		group by MaSach, TenSach, TACGIA.TenTG
		return
	end

select * from TACGIA
select * from NHAXB
select * from SACH
select * from cau02('Tac gia 01')
select * from cau02('Tac gia 02')
select * from cau02('Tac gia 04')


--Câu 3(3 đ): Hãy tạo thủ thêm mới 1 tác giả. Nếu tenTG đã có đưa ra thông báo!
create proc cau03(@MaTG char(10), @TenTG nvarchar(50), @SoLuongCo int)
as
	begin
		if(exists (select * from TACGIA where TACGIA.MaTG = @MaTG))
			print 'Tac gia: ' + @TenTG + ' da ton tai.'
		else
			insert into TACGIA values(@MaTG, @TenTG, @SoLuongCo)
	end

select * from TACGIA
select * from NHAXB
select * from SACH
exec cau03 'TG01', 'Tac gia 01', 5
exec cau03 'TG02', 'Tac gia 02', 7
exec cau03 'TG04', 'Tac gia 04', 6

