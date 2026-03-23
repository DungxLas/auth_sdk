---
description: Cập nhật tài liệu nghiệp vụ lib_doc mà không tạo code mới
---

# Update Doc Workflow

Dùng lệnh `/update_doc` khi USER muốn cập nhật, bổ sung hoặc đồng bộ lại tài liệu
nghiệp vụ trong `lib_doc/` mà không cần tạo thêm code mới.

**Bước 1: Quét hiện trạng**
- Liệt kê toàn bộ file `.dart` trong `lib/` (bỏ qua `main.dart`).
- Liệt kê toàn bộ file `.md` trong `lib_doc/`.
- Xác định:
  - File `.dart` nào **chưa có** file `.md` tương ứng → cần tạo mới.
  - File `.md` nào **mồ côi** (không có `.dart` tương ứng) → cần xoá hoặc đổi chỗ.

**Bước 2: Đọc file nguồn**
- Với mỗi file `.dart` cần cập nhật: đọc nội dung để nắm code hiện tại.
- Với mỗi file `.md` đã tồn tại: đọc nội dung để so sánh với code thực tế.

**Bước 3: Tạo / Cập nhật file Markdown**
- **Tạo mới** file `.md` cho những file `.dart` chưa có tài liệu.
- **Cập nhật** file `.md` đã cũ: chỉ sửa phần bị lỗi thời, giữ nguyên phần còn đúng.
- **Xoá** file `.md` mồ côi nếu file `.dart` tương ứng không còn tồn tại.

Nội dung file `.md` tập trung vào nghiệp vụ thuần tuý (KHÔNG chép code):
- Mục đích nghiệp vụ.
- Các hành vi chính: đầu vào, đầu ra, điều kiện thành công/thất bại.
- Quy tắc ràng buộc nghiệp vụ.
- Sơ đồ luồng trạng thái (nếu cần).

**Bước 4: Báo cáo**
- Danh sách file `.md` đã tạo mới.
- Danh sách file `.md` đã cập nhật (nêu rõ phần nào được sửa).
- Danh sách file `.md` đã xoá.
- Xác nhận `lib_doc/` đã đồng bộ 100% với `lib/`.
