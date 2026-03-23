# AuthState — Vòng đời trạng thái xác thực

## Mục đích nghiệp vụ

`AuthState` mô hình hoá **tất cả các trạng thái có thể xảy ra** trong vòng đời xác thực của người dùng. Mỗi trạng thái đại diện cho một giai đoạn cụ thể, từ lúc SDK chưa khởi tạo cho đến lúc người dùng hoàn tất đăng xuất.

Ứng dụng lắng nghe dòng trạng thái (`authStateStream`) để tự động điều hướng giao diện (ví dụ: chuyển sang màn hình đăng nhập khi chưa xác thực, chuyển sang màn hình chính khi đã xác thực).

---

## Máy trạng thái (State Machine)

```
[Uninitialized]
      ↓  (SDK.initialize() được gọi)
[Initialising]
      ↓  (hoàn thành khởi tạo, không có phiên cũ)
[Unauthenticated]  ←──────────────────────────────────────────────┐
      ↓  (người dùng gọi login())                                  │
[Authenticating]                                                    │
      ↓  (backend xác nhận thành công)                             │
[Authenticated] ──→ [RefreshingToken] ──→ [Authenticated]          │
      │                    ↓ (làm mới token thất bại)              │
      │             [Unauthenticated] ──────────────────────────────┘
      ↓  (người dùng gọi logout())
[LoggingOut]
      ↓
[Unauthenticated]
```

> Nếu có lỗi không phục hồi được tại bất kỳ bước nào, hệ thống chuyển sang `[AuthStateError]`.

---

## Danh sách trạng thái

### `AuthStateUninitialized` — Chưa khởi tạo
- **Khi nào xảy ra:** Ngay khi ứng dụng bật lên, trước khi gọi `AuthSDK.initialize()`.
- **Nghiệp vụ:** Mọi thao tác xác thực đều bị cấm ở trạng thái này.
- **Hành động UI:** Hiển thị màn hình splash / loading.

---

### `AuthStateInitialising` — Đang khởi tạo
- **Khi nào xảy ra:** Trong quá trình SDK thực hiện `initialize()` — tải token lưu trữ, kiểm tra phiên cũ.
- **Nghiệp vụ:** SDK đang cố gắng khôi phục phiên đăng nhập trước đó.
- **Hành động UI:** Giữ màn hình splash, chưa điều hướng.

---

### `AuthStateUnauthenticated` — Chưa xác thực
- **Khi nào xảy ra:**
  - Khởi tạo xong nhưng không có phiên nào được lưu trữ.
  - Sau khi đăng xuất thành công.
  - Sau khi làm mới token thất bại.
- **Nghiệp vụ:** SDK sẵn sàng nhận yêu cầu đăng nhập.
- **Hành động UI:** Điều hướng đến màn hình đăng nhập.

---

### `AuthStateAuthenticating` — Đang xác thực
- **Khi nào xảy ra:** Sau khi người dùng gửi yêu cầu đăng nhập, trong khi chờ backend phản hồi.
- **Nghiệp vụ:** Backend đang kiểm tra thông tin đăng nhập.
- **Hành động UI:** Hiển thị loading indicator, vô hiệu hoá nút đăng nhập.

---

### `AuthStateAuthenticated` — Đã xác thực ✅
- **Khi nào xảy ra:** Backend xác nhận đăng nhập thành công.
- **Dữ liệu đính kèm:** `userId` — ID người dùng hiện tại.
- **Nghiệp vụ:** Phiên đang hoạt động, token hợp lệ.
- **Hành động UI:** Điều hướng đến màn hình chính.

---

### `AuthStateRefreshingToken` — Đang làm mới token
- **Khi nào xảy ra:** Access token hết hạn, SDK đang gửi refresh token để lấy access token mới.
- **Dữ liệu đính kèm:** `userId` — người dùng vẫn được ghi nhận là đang đăng nhập.
- **Nghiệp vụ:** Người dùng KHÔNG bị đăng xuất trong thời gian này. Các request API đang chờ sẽ được tái thực thi sau khi token mới về.
- **Hành động UI:** Không thay đổi gì — người dùng không nhận ra.

---

### `AuthStateLoggingOut` — Đang đăng xuất
- **Khi nào xảy ra:** Sau khi người dùng gọi `logout()`, trong khi chờ backend xác nhận thu hồi phiên.
- **Nghiệp vụ:** Token đang được xoá khỏi storage và backend.
- **Hành động UI:** Có thể hiển thị loading ngắn.

---

### `AuthStateError` — Lỗi không phục hồi được
- **Khi nào xảy ra:** Xảy ra lỗi nghiêm trọng trong quá trình xác thực (ví dụ: lỗi hệ thống, cấu hình sai).
- **Dữ liệu đính kèm:** `exception` — chi tiết lỗi (xem `AuthException`).
- **Nghiệp vụ:** SDK rơi vào trạng thái lỗi; cần người dùng hoặc ứng dụng xử lý thủ công.
- **Hành động UI:** Hiển thị thông báo lỗi hệ thống.

---

## Quy tắc xử lý

> Luôn sử dụng `switch` toàn vẹn (exhaustive switch) khi xử lý `AuthState` để đảm bảo mọi trạng thái đều được xử lý. Nếu thêm trạng thái mới trong tương lai, compiler Dart sẽ cảnh báo ngay.
