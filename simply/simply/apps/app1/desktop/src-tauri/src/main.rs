#![cfg_attr(
    all(not(debug_assertions), target_os = "windows"),
    windows_subsystem = "windows"
)]

use tauri::{Manager, Window};

// Learn more about Tauri commands at https://tauri.app/v1/guides/features/command
#[tauri::command]
fn greet(name: &str) -> String {
    format!("Hello, {}! You've been greeted from Rust!", name)
}

#[tauri::command]
async fn call_backend(window: Window, endpoint: String) -> Result<String, String> {
    let client = reqwest::Client::new();
    let url = format!("http://localhost:8000{}", endpoint);
    
    match client.get(&url).send().await {
        Ok(response) => {
            match response.text().await {
                Ok(text) => Ok(text),
                Err(e) => Err(format!("Failed to get response text: {}", e))
            }
        },
        Err(e) => Err(format!("Failed to call backend: {}", e))
    }
}

fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![greet, call_backend])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
