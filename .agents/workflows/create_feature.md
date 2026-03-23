---
description: Cách để Antigravity tạo một tính năng mới hoặc logic block trong auth_sdk
---

# Quy trình tạo tính năng mới (Create Feature Workflow)

Khi USER yêu cầu tạo một tính năng mới, một model, hoặc một màn hình, hãy THỰC HIỆN NGHIÊM NGẶT các bước sau:

**Bước 1: Nạp bộ quy tắc (Context)**
- Đọc lại file `.cursorrules` (nằm ở thư mục gốc) để ghi nhớ các quy tắc (Rule) lập trình Flutter.
- Đảm bảo tuân thủ SOLID, Composition over Inheritance, và Immutability.

**Bước 2: Phân tích kiến trúc (Architecture)**
- Xác định Component này thuộc về layer nào theo mô hình: Presentation (widgets, screens), Domain (business logic), Data (model, api), hay Core (shared utilities).
- Lên kế hoạch cấu trúc thư mục rõ ràng theo `auth_sdk_technical_design.md`.

**Bước 3: Viết Code**
- Chia nhỏ hàm (< 20 dòng).
- Viết State Management bằng Native-First (`ValueNotifier`, `ChangeNotifier`). Tuyệt đối KHÔNG dùng Riverpod, Bloc, hay GetX.
- Bắt lỗi đàng hoàng (try-catch), log lỗi bằng `dart:developer`.

**Bước 4: Test (Kiểm thử)**
- Luôn luôn viết / cập nhật file `_test.dart` tương ứng trong thư mục `test/`.
- Ưu tiên sử dụng package `checks` cho validation. Dùng `mocktail` (KHÔNG DÙNG mockito, tránh code generation nếu có thể).
- Chạy test thông qua `run_tests` tool.

**Bước 5: Format & Analyze (Làm sạch code)**
- Dùng công cụ (hoặc terminal) chạy `dart format .`
- Dùng công cụ `analyze_files` (hoặc chạy `dart analyze`) để rà soát linter.
- Chạy `dart fix --apply` (hoặc dùng `dart_fix` tool) nếu công cụ phát hiện lỗi.

**Bước 6: Đồng bộ tài liệu nghiệp vụ (Sync lib_doc)**

Sau khi hoàn thành code, bắt buộc phải đồng bộ tài liệu nghiệp vụ trong `lib_doc/` để phản ánh đúng thực trạng codebase. Quy tắc:

- **Cấu trúc thư mục** trong `lib_doc/` phải **mirror hoàn toàn** cấu trúc `lib/`.
  - Mỗi file `.dart` trong `lib/` tương ứng với một file `.md` cùng tên trong `lib_doc/`.
  - Ví dụ: `lib/src/token/token_manager.dart` → `lib_doc/src/token/token_manager.md`

- **Nội dung** file markdown tập trung vào **nghiệp vụ thuần tuý** (KHÔNG chép code):
  - Mục đích nghiệp vụ của file/module.
  - Các hành vi (behaviours) chính: đầu vào, đầu ra, điều kiện thành công/thất bại.
  - Quy tắc ràng buộc nghiệp vụ (business rules).
  - Sơ đồ luồng dữ liệu hoặc trạng thái nếu cần thiết.
  - Hành động UI tương ứng (nếu có).

- **Khi tạo file mới** (`lib/src/x/y.dart`):
  → Tạo mới `lib_doc/src/x/y.md` với nội dung nghiệp vụ tương ứng.

- **Khi sửa file hiện có** (`lib/src/x/y.dart`):
  → Đọc lại `lib_doc/src/x/y.md`, đánh giá phần nào bị lỗi thời, rồi cập nhật đúng phần đó.

- **Khi xoá file** (`lib/src/x/y.dart`):
  → Xoá luôn `lib_doc/src/x/y.md` tương ứng.

**Bước 7: Báo cáo**
- Summary lại những file `.dart` đã tạo/sửa.
- Summary lại những file `.md` trong `lib_doc/` đã tạo/cập nhật.
- Thông báo kết quả linter và test cho USER.
