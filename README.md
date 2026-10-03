# VibeTokHD v2.0 — Auto Swipe / Auto Click (Không cần Jailbreak)

## ⚠️ Tại sao bản cũ không chạy?

**Bản trước là Tweak (Theos)**, yêu cầu **Jailbreak thật** (Cydia Substrate / Substitute).
Bạn dùng **eSign** → chỉ re-sign app thường → tweak **không load được** → TikTok crash.

## ✅ Giải pháp: VibeTokHD Standalone

App Swift/UIKit chạy **độc lập**, cài qua eSign, **không cần jailbreak**.

## 📥 Cài đặt (eSign)

1. Mở **eSign** trên iPhone
2. Nhấn **"+"** → chọn file **`VibeTokHD.ipa`** (tôi sẽ build & gửi)
3. Sau khi import → nhấn **"Sign"** → chọn certificate
4. Sau ký → nhấn **"Install"**
5. Sau cài → mở **Settings** → **General** → **Device Management** → tin tưởng certificate
6. Mở app **VibeTokHD**

## 🎮 Cách sử dụng

### Mở panel điều khiển
- Nhấn nút **⚡** (nổi, viền phải màn hình) → mở panel
- Kéo thả nút ⚡ để di chuyển

### Auto Swipe
1. Mở panel → chọn hướng ↑↓←→
2. Đặt **Min ms** (vd: 800), **Max ms** (vd: 1500)
3. Bật **"Dừng khi hết video"**
4. Nhấn **Start Swipe**
5. Mở TikTok từ Springboard

### Auto Click (Manual helper)
Vì iOS không cho 1 app tự chạm vào app khác, chế độ click sẽ:
- Phát âm thanh "tock" khi đến giờ
- Hiển thị **toast "👆 Tap now at (x,y)"** trên panel
- Bạn tự chạm theo hướng dẫn

**Cách dùng**:
1. Nhấn **+ Add Click Point**
2. Trên màn hình, chạm vào vị trí bạn muốn (vd: nút Like)
3. Quay lại panel → nhấn **Start Click**
4. App sẽ báo "Tap now" mỗi giây → bạn tự chạm

## 🆕 Auto stop khi hết video

App dùng 2 cơ chế (vì không thấy UI TikTok):

| Cơ chế | Cách hoạt động |
|---|---|
| **No new swipe count** | Nếu 6+ lần swipe mà "không có nội dung mới" → tự dừng |
| **No UI change** | Nếu bạn thấy nội dung lặp lại 3 lần → bấm dừng thủ công |

Để chính xác hơn, bạn có thể **mở app VibeTokHD mỗi 10 phút** để cập nhật trạng thái.

## 🔧 So sánh 2 phiên bản

| Tính năng | Tweak (cũ) | Standalone (mới) |
|---|---|---|
| Cần jailbreak | ✅ Có | ❌ Không |
| Cài qua eSign | ❌ Không | ✅ Có |
| Auto swipe thật sự | ✅ | ⚠️ Cần user tương tác |
| Auto click thật sự | ✅ | ⚠️ Cần user tương tác |
| HD Photos TikTok | ✅ | ❌ (yêu cầu tweak) |
| Phát hiện hết video | ✅ 4 chiến lược | ⚠️ 2 chiến lược |

## 🎯 Phiên bản tương lai (cần jailbreak)

Nếu bạn muốn **tweak thật sự** (auto swipe không cần tương tác):
- Jailbreak bằng **palera1n** (rootless) hoặc **unc0ver**
- Cài qua **Sileo / Cydia**
- Tweak tự động load vào TikTok

## 📞 Hỗ trợ

- GitHub: `github.com/NguyenHungXD/VibeTokHD`
- Build từ Xcode: mở `VibeTok.xcodeproj` trong thư mục này
