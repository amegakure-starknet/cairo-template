#[derive(Drop, Serde, starknet::Store)]
pub struct BeastStats {
    pub tier: u8,
    pub level: u8,
    pub health: u32,
    pub attack: u32,
    pub type_beast: u8
}
