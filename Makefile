-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil deployMood

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

help:
	@echo "Usage:"
	@echo "  make deploy [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""
	@echo ""
	@echo "  make fund [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install cyfrin/foundry-devops@0.2.2 && forge install foundry-rs/forge-std@v1.8.2 && forge install openzeppelin/openzeppelin-contracts@v5.0.2

deploy-sepolia:
	@echo "Deploying to Sepolia..."
	@forge script script/DeployBasicNft.s.sol:DeployBasicNft --rpc-url $(SEPOLIA_RPC_URL) --account myaccount --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

mint:
	@echo "Minting NFT..."
	@forge script script/Interactions.s.sol:MintBasicNft --rpc-url $(SEPOLIA_RPC_URL) --account myaccount --broadcast

deployMood-anvil:
	@echo "Deploying MoodNft on Anvil..."
	@forge script script/DeployMoodNft.s.sol:DeployMoodNft --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

mintMood-anvil:
	@echo "Minting MoodNft on Anvil..."
	@cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 "mintNft()" --private-key $(DEFAULT_ANVIL_KEY) --rpc-url http://localhost:8545

flipMood-anvil:
	@echo "Flipping MoodNft on Anvil..."
	@cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 "flipMood(uint256)" 0 --private-key $(DEFAULT_ANVIL_KEY) --rpc-url http://localhost:8545