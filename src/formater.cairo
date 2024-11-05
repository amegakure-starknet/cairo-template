use alexandria_encoding::base64::Base64Encoder;
use cairo_template::encoding::bytes_base64_encode;
use graffiti::json::JsonImpl;
use cairo_template::beast_stats::BeastStats;

pub fn create_metadata(
    beast_stats: BeastStats,
    token_id: u256,
    base_uri: ByteArray
) -> ByteArray {
    
    let name_beast = get_name_beast(token_id);
    let type_name_beast = get_type_name_beast(token_id);

    let _token_id = format!("{}", token_id);
    let _type_beast = format!("{}", beast_stats.type_beast);
    let _tier = format!("{}", beast_stats.tier);
    let _level = format!("{}",beast_stats.level);
    let _health = format!("{}",beast_stats.health);
    let _attack = format!("{}", beast_stats.attack);

    let mut metadata = JsonImpl::new()
        .add("name", name_beast + " #" + _token_id)
        .add(
            "description",
            "Beasts"
        )
        .add("image", base_uri + _type_beast);

    let tier: ByteArray = JsonImpl::new().add("trait_type", "tier").add("value", _tier).build();
    let level: ByteArray = JsonImpl::new().add("trait_type", "level").add("value", _level).build();
    let health: ByteArray = JsonImpl::new().add("trait_type", "health").add("value", _health).build();
    let attack: ByteArray = JsonImpl::new().add("trait_type", "attack").add("value", _attack).build();
    let type_beast: ByteArray = JsonImpl::new().add("trait_type", "type").add("value", type_name_beast).build();

    let attributes = array![
        tier,
        level,
        health,
        attack,
        type_beast
    ].span();

    let metadata = metadata.add_array("attributes", attributes).build();

    // format!("data:application/json;base64,{}", bytes_base64_encode(metadata))
    format!("data:application/json;utf8,{}", metadata)
}

fn get_name_beast(
    token_id: u256,
) -> ByteArray {
    if token_id == 101 {
        "Fallen Jack"
    } else if  token_id == 102 {
        "Fallen Queen"
    } else if  token_id == 103 {
        "Fallen King"
    } else if  token_id == 104 {
        "Fallen Joker"
    } else if  token_id == 105 {
        "Fallen Neon Jack"
    } else if  token_id == 106 {
        "Fallen Neon Queen"
    } else if  token_id == 107 {
        "Fallen Neon King"
    } else if  token_id == 108 {
        "Fallen Neon Joker"
    } else {
        ""
    }
}

fn get_type_name_beast(
    token_id: u256,
) -> ByteArray {
    if token_id >= 101 && token_id <= 104 {
        "Common"
    } else {
        "Neon"
    }
}

