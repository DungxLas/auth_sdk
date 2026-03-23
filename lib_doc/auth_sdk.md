# AuthSDK — Tổng quan nghiệp vụ

## Mục đích

`auth_sdk` là SDK xác thực (Authentication SDK) dành cho ứng dụng Flutter mobile. SDK cung cấp **một điểm truy cập duy nhất và ổn định** cho toàn bộ các nghiệp vụ xác thực, che giấu hoàn toàn chi tiết cài đặt nội bộ đối với người dùng thư viện.

## Phạm vi nghiệp vụ

SDK chịu trách nhiệm quản lý các nghiệp vụ sau:

| Nghiệp vụ | Mô tả |
|---|---|
| **Khởi tạo SDK** | Cấu hình SDK với tenant ID và backend provider trước khi sử dụng |
| **Đăng nhập** | Xác thực người dùng bằng email và mật khẩu |
| **Đăng xuất** | Kết thúc phiên làm việc và thu hồi token |
| **Làm mới Token** | Tự động gia hạn access token hết hạn bằng refresh token |
| **Theo dõi trạng thái** | Phát sóng (stream) trạng thái xác thực hiện tại liên tục |

## Luồng sử dụng cơ bản

```
1. Ứng dụng khởi động
        ↓
2. Khởi tạo SDK (initialize) với tenantId + provider
        ↓
3. SDK tự động khôi phục phiên cũ (nếu có token lưu trữ)
        ↓
4. Ứng dụng lắng nghe authStateStream để điều hướng UI
        ↓
5. Người dùng đăng nhập → SDK phát trạng thái Authenticated
        ↓
6. (Sau này) Access token hết hạn → SDK tự động làm mới
        ↓
7. Người dùng đăng xuất → SDK xóa token và phát trạng thái Unauthenticated
```

## Module con được xuất ra ngoài

| Module | File nguồn | Vai trò nghiệp vụ |
|---|---|---|
| **AuthState** | `src/core/auth_state.dart` | Trạng thái vòng đời xác thực |
| **AuthException** | `src/errors/auth_exception.dart` | Phân loại lỗi xác thực |
| **AuthToken** | `src/models/auth_token.dart` | Dữ liệu token sau đăng nhập |
| **AuthProvider** | `src/providers/auth_provider.dart` | Hợp đồng với backend xác thực |

> **Quy tắc quan trọng:** Người dùng SDK chỉ được phép import từ `auth_sdk.dart` — KHÔNG import trực tiếp từ các file bên trong `src/`.
