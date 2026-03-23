---
description: Chạy nhanh toàn bộ kiểm tra chất lượng (format + analyze + test) trên dự án
---

# Run Checks Workflow

Dùng lệnh `/run_checks` bất kỳ lúc nào để xác minh toàn bộ dự án đang ở trạng thái sạch.

**Bước 1: Format code**
- Chạy `dart_format` tool trên toàn bộ project.
- Kiểm tra có file nào bị thay đổi không — nếu có, commit sau khi chạy.

**Bước 2: Phân tích tĩnh (Static Analysis)**
- Chạy `analyze_files` tool để rà soát toàn bộ linter.
- Nếu có lỗi hoặc warning, chạy `dart_fix` để tự động sửa.
- Báo cáo danh sách lỗi còn lại nếu `dart_fix` không giải quyết được.

**Bước 3: Chạy toàn bộ Tests**
- Chạy `run_tests` tool trên toàn bộ project.
- Báo cáo: tổng số test, số pass, số fail.
- Nếu có test fail, đọc output lỗi và đề xuất hướng sửa.

**Bước 4: Kiểm tra đồng bộ lib_doc**
- Quét `lib/` để liệt kê tất cả file `.dart` (bỏ qua `main.dart`).
- Quét `lib_doc/` để liệt kê tất cả file `.md`.
- So sánh hai danh sách — báo cáo nếu có file `.dart` nào chưa có `.md` tương ứng trong `lib_doc/`.

**Bước 5: Báo cáo tổng kết**
Xuất bảng tổng hợp:
- ✅ Format: sạch / ❌ có thay đổi
- ✅ Analyze: No errors / ❌ N lỗi
- ✅ Tests: N/N passed / ❌ N failed
- ✅ lib_doc: đầy đủ / ⚠️ thiếu N file
