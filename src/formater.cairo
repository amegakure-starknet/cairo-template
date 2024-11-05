use alexandria_encoding::base64::Base64Encoder;
use cairo_template::encoding::bytes_base64_encode;
use graffiti::json::JsonImpl;
use cairo_template::beast_stats::BeastStats;

pub fn create_metadata(beast_stats: BeastStats, token_id: u256, base_uri: ByteArray) -> ByteArray {
    let name_beast = get_name_beast(beast_stats.beast_id.try_into().unwrap());
    let _token_id = format!("{}", token_id);
    let _beast_id = format!("{}", beast_stats.beast_id);
    let _tier = format!("{}", beast_stats.tier);
    let _level = format!("{}", beast_stats.level);

    let mut metadata = JsonImpl::new()
        .add("name", name_beast.clone())
        .add("description", "Jokers of Neon x Loot Survivor exclusive beast")
        .add("image", base_uri + _beast_id + ".png");

    let tier: ByteArray = JsonImpl::new().add("trait_type", "tier").add("value", _tier).build();
    let level: ByteArray = JsonImpl::new().add("trait_type", "level").add("value", _level).build();
    let name_beast_json: ByteArray = JsonImpl::new()
        .add("trait_type", "beast id")
        .add("value", name_beast)
        .build();

    let attributes = array![name_beast_json, tier, level, ].span();

    let metadata = metadata.add_array("attributes", attributes).build();

    // format!("data:application/json;base64,{}", bytes_base64_encode(metadata))
    format!("data:application/json;utf8,{}", metadata)
}

fn get_name_beast(token_id: u256) -> ByteArray {
    if token_id == 101 {
        "Fallen Jack"
    } else if token_id == 102 {
        "Fallen Queen"
    } else if token_id == 103 {
        "Fallen King"
    } else if token_id == 104 {
        "Fallen Joker"
    } else if token_id == 105 {
        "Fallen Neon Jack"
    } else if token_id == 106 {
        "Fallen Neon Queen"
    } else if token_id == 107 {
        "Fallen Neon King"
    } else if token_id == 108 {
        "Fallen Neon Joker"
    } else {
        "id error"
    }
}
