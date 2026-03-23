# AuthException & AuthErrorCode — Phân loại lỗi xác thực

## Mục đích nghiệp vụ

`AuthException` là kiểu lỗi duy nhất được ném ra bởi mọi thao tác xác thực trong SDK. Thay vì ném các lỗi chung chung (`Exception`, `Error`), SDK luôn đóng gói lỗi trong `AuthException` kèm theo một **mã lỗi cố định** (`code`) và **mô tả đọc được** (`message`).

Điều này cho phép ứng dụng xử lý từng loại lỗi cụ thể theo đúng nghiệp vụ mà không cần phân tích chuỗi ký tự.

---

## Cấu trúc lỗi

| Trường | Kiểu | Vai trò |
|---|---|---|
| `code` | `String` | Mã lỗi cố định (dùng hằng số từ `AuthErrorCode`) |
| `message` | `String` | Mô tả lỗi cho developer đọc — KHÔNG hiển thị cho người dùng cuối |
| `originalError` | `Object?` | Lỗi gốc từ hệ thống (network, Firebase, v.v.) — phục vụ debug |

> **Quy tắc UX:** `message` trong `AuthException` là mô tả kỹ thuật. Ứng dụng cần **tự định nghĩa thông báo thân thiện** với người dùng dựa theo `code`.

---

## Danh sách mã lỗi (`AuthErrorCode`)

### `INVALID_CREDENTIALS` — Thông tin đăng nhập sai
- **Khi nào xảy ra:** Email hoặc mật khẩu không đúng khi đăng nhập.
- **Nghiệp vụ:** Backend từ chối xác thực vì thông tin không khớp.
- **Hành động UI:** Hiển thị thông báo "Email hoặc mật khẩu không đúng".

---

### `TOKEN_EXPIRED` — Access token hết hạn
- **Khi nào xảy ra:** Access token đã quá thời gian hiệu lực, cần làm mới.
- **Nghiệp vụ:** SDK phải thực hiện refresh token. Nếu refresh thành công, request gốc được tái thực thi tự động.
- **Hành động UI:** Thường người dùng không cần biết (SDK xử lý tự động).

---

### `REFRESH_FAILED` — Làm mới token thất bại
- **Khi nào xảy ra:** Refresh token không hợp lệ, đã hết hạn, hoặc bị thu hồi bởi backend.
- **Nghiệp vụ:** SDK không thể duy trì phiên — người dùng phải đăng nhập lại.
- **Hành động UI:** Đăng xuất cưỡng bức, điều hướng về màn hình đăng nhập với thông báo "Phiên đăng nhập đã hết hạn".

---

### `NETWORK_ERROR` — Lỗi mạng
- **Khi nào xảy ra:** Không thể kết nối đến server xác thực (mất mạng, timeout, lỗi DNS).
- **Nghiệp vụ:** Thao tác xác thực không thể hoàn thành vì nguyên nhân hạ tầng — KHÔNG phải lỗi nghiệp vụ.
- **Hành động UI:** Hiển thị thông báo "Kiểm tra kết nối mạng và thử lại".

---

### `SESSION_REVOKED` — Phiên bị thu hồi từ server
- **Khi nào xảy ra:** Server chủ động vô hiệu hoá phiên đăng nhập (ví dụ: admin khoá tài khoản, phát hiện đăng nhập bất thường, thay đổi mật khẩu từ thiết bị khác).
- **Nghiệp vụ:** Phiên hiện tại không còn hợp lệ dù token chưa hết hạn — người dùng bị đăng xuất.
- **Hành động UI:** Đăng xuất ngay, hiển thị "Phiên đăng nhập của bạn đã bị kết thúc từ xa".

---

### `NOT_INITIALISED` — SDK chưa được khởi tạo
- **Khi nào xảy ra:** Ứng dụng gọi `AuthSDK.instance.login()` hoặc các thao tác khác trước khi gọi `AuthSDK.initialize()`.
- **Nghiệp vụ:** Lỗi lập trình — SDK chưa sẵn sàng.
- **Hành động UI:** Không nên hiển thị cho người dùng; đây là lỗi của developer.

---

## Hướng dẫn xử lý lỗi

```
try {
  Đăng nhập / thao tác xác thực
} catch AuthException với mã INVALID_CREDENTIALS {
  → Thông báo "Email hoặc mật khẩu không đúng"
} catch AuthException với mã NETWORK_ERROR {
  → Thông báo "Kiểm tra kết nối mạng"
} catch AuthException với mã REFRESH_FAILED / SESSION_REVOKED {
  → Đăng xuất cưỡng bức, về màn hình đăng nhập
} catch AuthException khác {
  → Ghi log, hiển thị lỗi chung
}
```

> **Không bao giờ** catch `Exception` hay `Error` chung rồi bỏ qua — hãy luôn log `originalError` để phục vụ debug.
