const std = @import("std");

const CallbackType = *const fn (id: [*:0]const u8, req: [*:0]const u8) void;
                                                  fn callbackZig(id: [*:0]const u8, req: [*:0]const u8) void {                                            const json_req = std.mem.span(req); // json_req is "[5]"

    // Taktik Koboi: Bersihkan karakter bungkusan [ dan ] secara manual
    // Kita cari karakter angka di antara kurung siku
    var angka_saja: []const u8 = "";                  for (json_req) |char| {
        if (char >= '0' and char <= '9') {                    // Kita ambil irisan string yang berisi angka saja                                                  angka_saja = json_req[1 .. json_req.len - 1];                                                       break;
        }
    }

    // Ubah string angka murni tadi menjadi integer asli di CPU
    const angka_dari_js = std.fmt.parseInt(i32, angka_saja, 10) catch {
        webviewReturn(id, 1, "Gagal konversi angka manual");
        return;
    };

    // Eksekusi matematika murni Zig (Angka dikali 100)
    const hasil_hitung = angka_dari_js * 100;

    // Cetak hasilnya ke dalam buffer teks            var buf: [32]u8 = undefined;
    const hasil_string = std.fmt.bufPrint(&buf, "{}", .{hasil_hitung}) catch "0";
                                                      // Lempar balik hasilnya ke browser
    webviewReturn(id, 0, hasil_string);           }

fn webviewBind(name: []const u8, cb: CallbackType) void {
    std.debug.print("[Webview] Jembatan \"{s}\" Berhasil Terpasang!\n", .{name});
    std.debug.print("[Simulasi] JavaScript mengklik tombol dan mengirim data: \"[5]\"\n", .{});
    cb("request_id_123", "[5]");
}

fn webviewReturn(id: [*:0]const u8, status: i32, result: []const u8) void {
    _ = id;
    _ = status;
    std.debug.print("[Simulasi] JavaScript menerima balikan dari Zig!\n", .{});
    std.debug.print("\x1b[32m👉 RESPONS AKHIR DI BROWSER: {s}\x1b[0m\n", .{result});                }

pub fn main() !void {
    std.debug.print("[Webview] Set Title: Aplikasi Jembatan Zig\n", .{});
    webviewBind("resep_zig", callbackZig);
    std.debug.print("[Webview] Membuka Halaman: index.html\n", .{});
    std.debug.print("[Webview] Aplikasi selesai berjalan.\n", .{});
}
