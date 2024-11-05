// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts for Cairo ^0.18.0

#[starknet::contract]
mod MyToken {
    use core::num::traits::Zero;
    use openzeppelin::introspection::src5::SRC5Component;
    use openzeppelin::token::erc721::ERC721Component;
    use openzeppelin::token::erc721::ERC721HooksEmptyImpl;
    use openzeppelin::token::erc721::interface::{IERC721Metadata, IERC721MetadataCamelOnly};
    use starknet::{ContractAddress, get_caller_address};

    use starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map
    };
    use openzeppelin::access::ownable::OwnableComponent;

    use cairo_template::beast_stats::BeastStats;
    use cairo_template::formater::create_metadata;

    component!(path: ERC721Component, storage: erc721, event: ERC721Event);
    component!(path: SRC5Component, storage: src5, event: SRC5Event);
    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);

    // ERC721Mixin can't be used since we have a custom implementation for Metadata
    #[abi(embed_v0)]
    impl ERC721Impl = ERC721Component::ERC721Impl<ContractState>;
    #[abi(embed_v0)]
    impl ERC721CamelOnly = ERC721Component::ERC721CamelOnlyImpl<ContractState>;

    #[abi(embed_v0)]
    impl OwnableMixinImpl = OwnableComponent::OwnableMixinImpl<ContractState>;

    impl ERC721InternalImpl = ERC721Component::InternalImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        erc721: ERC721Component::Storage,
        #[substorage(v0)]
        src5: SRC5Component::Storage,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
        beasts_stats: Map<u256, BeastStats>,
        beasts_owners: Map<(u8, u8, u8), ContractAddress>,
        total_supply: u256,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC721Event: ERC721Component::Event,
        #[flat]
        SRC5Event: SRC5Component::Event,
        #[flat]
        OwnableEvent: OwnableComponent::Event,
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        self.erc721.initializer("JN_BEAST", "BEAST", "https://ls.jokersofneon.com/beasts/");
        self.ownable.initializer(owner);
    }

    #[abi(embed_v0)]
    impl ERC721CustomMetadataImpl of IERC721Metadata<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            self.erc721.name()
        }

        fn symbol(self: @ContractState) -> ByteArray {
            self.erc721.symbol()
        }

        fn token_uri(self: @ContractState, token_id: u256) -> ByteArray {
            let base_uri = self.erc721._base_uri();
            let beast_stats = self.beasts_stats.entry(token_id).read();
            create_metadata(beast_stats, token_id, base_uri)
        }
    }

    #[abi(embed_v0)]
    impl ERC721CustomMetadataCamelOnlyImpl of IERC721MetadataCamelOnly<ContractState> {
        fn tokenURI(self: @ContractState, tokenId: u256) -> ByteArray {
            self.token_uri(tokenId)
        }
    }

    #[generate_trait]
    #[abi(per_item)]
    impl ExternalImpl of ExternalTrait {
        #[external(v0)]
        fn safe_mint(
            ref self: ContractState, recipient: ContractAddress, beast_stats: BeastStats,
        ) {
            self.ownable.assert_only_owner();
            let beast_owner = self
                .beasts_owners
                .entry((beast_stats.tier, beast_stats.level, beast_stats.beast_id))
                .read();
            assert(beast_owner.is_zero(), 'already minted beast');

            let total_supply = self.total_supply.read();
            let token_id = total_supply + 1;
            self.total_supply.write(token_id);

            self.erc721.safe_mint(recipient, token_id, array![].span());
            self.beasts_stats.entry(token_id).write(beast_stats);
            self
                .beasts_owners
                .entry((beast_stats.tier, beast_stats.level, beast_stats.beast_id))
                .write(get_caller_address());
        }

        #[external(v0)]
        fn safeMint(ref self: ContractState, recipient: ContractAddress, beast_stats: BeastStats,) {
            self.safe_mint(recipient, beast_stats);
        }

        #[external(v0)]
        fn get_owner(self: @ContractState, beast_stats: BeastStats,) -> ContractAddress {
            self
                .beasts_owners
                .entry((beast_stats.tier, beast_stats.level, beast_stats.beast_id))
                .read()
        }

        #[external(v0)]
        fn get_beast_stats(self: @ContractState, token_id: u256,) -> BeastStats {
            self.beasts_stats.entry(token_id).read()
        }

        #[external(v0)]
        fn getBeastStats(self: @ContractState, tokenId: u256,) -> BeastStats {
            self.beasts_stats.entry(tokenId).read()
        }

        #[external(v0)]
        fn total_supply(self: @ContractState,) -> u256 {
            self.total_supply.read()
        }

        #[external(v0)]
        fn totalSupply(self: @ContractState,) -> u256 {
            self.total_supply.read()
        }
    }
}
