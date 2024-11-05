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
    let _token_id = format!("{}", token_id);
    let _beast_id = format!("{}", beast_stats.beast_id);
    let _tier = format!("{}", beast_stats.tier);
    let _level = format!("{}",beast_stats.level);

    let mut metadata = JsonImpl::new()
        .add("name", name_beast.clone() + " #" + _token_id)
        .add(
            "description",
            "Beasts"
        )
        .add("image", base_uri + _beast_id);

    let tier: ByteArray = JsonImpl::new().add("trait_type", "tier").add("value", _tier).build();
    let level: ByteArray = JsonImpl::new().add("trait_type", "level").add("value", _level).build();
    let name_beast_json: ByteArray = JsonImpl::new().add("trait_type", "beast_id").add("value", name_beast).build();

    let attributes = array![
        tier,
        level,
        name_beast_json
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
