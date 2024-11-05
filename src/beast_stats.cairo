#[derive(Drop, Copy, Serde, starknet::Store)]
pub struct BeastStats {
    pub tier: u8,
    pub level: u8,
    pub beast_id: u8
}
