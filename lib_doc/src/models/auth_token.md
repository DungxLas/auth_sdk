# AuthToken — Dữ liệu token xác thực

## Mục đích nghiệp vụ

`AuthToken` là **đối tượng bất biến (immutable)** đại diện cho cặp token trả về sau khi người dùng đăng nhập thành công. SDK sử dụng đối tượng này để:

1. Uỷ quyền (authorize) các API request bằng `accessToken`.
2. Duy trì phiên đăng nhập bằng `refreshToken` khi `accessToken` hết hạn.
3. Nhận diện người dùng hiện tại thông qua `userId`.

---

## Cấu trúc dữ liệu

| Trường | Bắt buộc | Mô tả nghiệp vụ |
|---|---|---|
| `accessToken` | ✅ | Token ngắn hạn dùng để gọi API (thường hết hạn sau 15 phút – 1 giờ) |
| `refreshToken` | ✅ | Token dài hạn dùng để lấy `accessToken` mới (thường hết hạn sau 7-30 ngày) |
| `userId` | ✅ | ID định danh người dùng mà token này thuộc về |
| `expiresAt` | ⬜ (tuỳ chọn) | Thời điểm UTC mà `accessToken` hết hiệu lực. `null` nếu backend không cung cấp |

---

## Nghiệp vụ kiểm tra hết hạn (`isExpired`)

SDK tự động kiểm tra token có hết hạn chưa trước khi gọi API:

| Trường hợp | Kết quả `isExpired` | Ý nghĩa |
|---|---|---|
| `expiresAt` là `null` | `false` | Không biết thời hạn — giả định còn hợp lệ, để backend xác nhận |
| `expiresAt` là thời điểm trong tương lai | `false` | Token còn hạn — không cần làm mới |
| `expiresAt` đã qua (trong quá khứ) | `true` | Token hết hạn — SDK phải làm mới trước khi gọi API |

> **Lưu ý bảo mật:** Kiểm tra `isExpired` là kiểm tra **phòng ngừa phía client** — không thay thế việc backend từ chối token hết hạn. Nếu backend báo lỗi `TOKEN_EXPIRED`, SDK vẫn phải xử lý bằng refresh flow bất kể giá trị `isExpired`.

---

## Vòng đời token

```
Đăng nhập thành công
        ↓
Nhận cặp (accessToken, refreshToken, expiresAt)
        ↓
Gọi API với accessToken trong Authorization header
        ↓
isExpired? hoặc backend trả lỗi TOKEN_EXPIRED?
        ↓ (Có)
Gọi refreshToken để lấy cặp token mới
        ↓
Lưu token mới vào Secure Storage
        ↓
Tái thực thi API request ban đầu
        ↓
Nếu refresh thất bại → Đăng xuất cưỡng bức
```

---

## Nguyên tắc lưu trữ

- Token **KHÔNG ĐƯỢC** lưu trong SharedPreferences hay bộ nhớ thông thường.
- Token phải được lưu trong **Secure Storage** (Keychain trên iOS, EncryptedSharedPreferences trên Android).
- Khi đăng xuất, **toàn bộ** token (access + refresh) phải được xoá ngay lập tức.
- `userId` có thể được lưu riêng để phục vụ UI offline, nhưng token phải xoá sạch.
