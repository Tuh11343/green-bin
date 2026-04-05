# Green Bin

Green Bin là một ứng dụng di động quản lý rác thải bằng Flutter. Ứng dụng cho phép người dùng tạo báo cáo về rác thải, ghi nhận vị trí và thông tin liên quan, đồng thời tích lũy điểm để đổi quà.

## Tính năng chính

- Tạo báo cáo rác thải với mô tả, vị trí và hình ảnh.
- Quản lý lịch sử báo cáo của người dùng.
- Hệ thống điểm thưởng và đổi quà.
- Quản lý thông tin tài khoản cá nhân.
- Đăng nhập bằng tài khoản google.

## Công nghệ sử dụng

| Công nghệ      | Mục đích                      |
|----------------|-------------------------------|
| Flutter        | Framework phát triển ứng dụng |
| Google Sign-In | Xác thực người dùng           |
| GoRouter       | Điều hướng màn hình           |
| Flutter BLoC   | Quản lý trạng thái            |
| Google Maps    | Hiển thị và chọn vị trí       |


## Kiến trúc

Dự án sử dụng kiến trúc phân lớp (Layered Architecture) để tách biệt các trách nhiệm:

- **Present Layer**: `screens/`, `widgets/` — Giao diện người dùng và logic hiển thị.
- **Business Layer**: `bloc/cubit` — Quản lý logic nghiệp vụ và trạng thái ứng dụng.
- **Persistent Layer**: `repository` — Xử lý truy cập dữ liệu và giao tiếp với backend.

## Trạng thái phát triển

> ⚠️ Dự án đang trong giai đoạn phát triển ban đầu.

- ✅ Phần **người dùng (user)** — đang phát triển
- 🚧 Phần **collector** — chưa hoàn thiện
- 🚧 Phần **admin** — chưa hoàn thiện
