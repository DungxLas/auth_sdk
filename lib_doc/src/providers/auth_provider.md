# AuthProvider — Hợp đồng với backend xác thực

## Mục đích nghiệp vụ

`AuthProvider` là **hợp đồng nghiệp vụ (interface)** định nghĩa những gì mà bất kỳ backend xác thực nào cũng phải cung cấp để tích hợp vào SDK.

Thiết kế này tuân theo nguyên tắc **Open/Closed** (SOLID): SDK core luôn đóng với việc sửa đổi, nhưng mở để mở rộng (thêm backend mới) thông qua `AuthProvider`.

---

## Danh sách hành vi nghiệp vụ

### `login(email, password)` — Đăng nhập

| Hạng mục | Mô tả |
|---|---|
| **Đầu vào** | `email`: địa chỉ email của người dùng, `password`: mật khẩu |
| **Đầu ra thành công** | Một `AuthToken` hợp lệ gồm access token, refresh token, userId |
| **Đầu ra thất bại** | Ném `AuthException` với mã `INVALID_CREDENTIALS` hoặc `NETWORK_ERROR` |
| **Tác dụng phụ** | Backend tạo một phiên đăng nhập mới trên server |

**Quy tắc nghiệp vụ:**
- Email phải được chuẩn hoá (lowercase, trim) trước khi gửi lên backend.
- Mật khẩu KHÔNG được log, cache, hay lưu lại ở bất kỳ đâu.
- Số lần thử đăng nhập sai có thể bị giới hạn bởi backend (rate limiting).

---

### `logout()` — Đăng xuất

| Hạng mục | Mô tả |
|---|---|
| **Đầu vào** | Không có (phiên hiện tại được xác định qua token đang lưu) |
| **Đầu ra thành công** | `void` |
| **Đầu ra thất bại** | Ném `AuthException` — nhưng SDK vẫn nên xoá token local kể cả khi backend thất bại |
| **Tác dụng phụ** | Backend thu hồi refresh token; client xoá toàn bộ token khỏi Secure Storage |

**Quy tắc nghiệp vụ:**
- Đăng xuất phải **luôn xoá token local** dù backend có phản hồi hay không — tránh trường hợp mất mạng khiến người dùng không thể đăng xuất.
- Nếu backend báo lỗi khi đăng xuất, SDK nên ghi log nhưng vẫn hoàn tất đăng xuất phía client.

---

### `refreshToken(refreshToken)` — Làm mới token

| Hạng mục | Mô tả |
|---|---|
| **Đầu vào** | `refreshToken`: chuỗi refresh token hiện đang được lưu trữ |
| **Đầu ra thành công** | Một `AuthToken` mới với access token và refresh token mới |
| **Đầu ra thất bại** | Ném `AuthException` với mã `REFRESH_FAILED` |
| **Tác dụng phụ** | Backend vô hiệu refresh token cũ và cấp token mới (token rotation) |

**Quy tắc nghiệp vụ:**
- Refresh token phải được thực thi với **Concurrency Lock** — nếu nhiều API call cùng lúc phát hiện token hết hạn, chỉ **một** request refresh được gửi đi, các request còn lại chờ kết quả.
- Nếu refresh thất bại với `REFRESH_FAILED`, SDK phải bắt buộc đăng xuất người dùng ngay lập tức.
- Token mới nhận được phải được lưu vào Secure Storage trước khi tái thực thi các request đang chờ.

---

## Hướng dẫn triển khai backend

Để cắm một backend mới vào SDK, cần tạo một class implement `AuthProvider`:

| Backend | Gợi ý triển khai |
|---|---|
| **Firebase Authentication** | Dùng `firebase_auth` package, map `UserCredential` → `AuthToken` |
| **REST API tuỳ chỉnh** | Dùng `dio` hoặc `http`, gọi endpoint `/auth/login`, `/auth/logout`, `/auth/refresh` |
| **Mock (cho testing)** | Tạo `FakeAuthProvider` trả về token giả — không gọi mạng thật |

> **Nguyên tắc cách ly:** `AuthProvider` **không được** trực tiếp lưu token hay quản lý state. Trách nhiệm đó thuộc về `TokenManager` và `SessionManager` trong core SDK.
